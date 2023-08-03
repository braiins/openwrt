REQUIRE_IMAGE_METADATA=1

flush_all() {
	sync
	echo 3 > /proc/sys/vm/drop_caches
}

sysupgrade_dir() {
	echo "sysupgrade-$(bos_build)-$(bos_mode)"
	return 0
}

source_sysupgrade_command() {
	local command_file command_path command_length

	command_file="/tmp/sysupgrade-COMMAND"
	command_path="$(sysupgrade_dir)/COMMAND"
	command_length=$(
		(get_image "$@" | tar xf - $command_path -O | wc -c) 2>/dev/null
	)

	if [ "$command_length" == 0 ]; then
		v "Missing or empty sysupgrade 'COMMAND' file"
		return 1
	fi

	get_image "$@" | tar xf - "$command_path" -O > "$command_file"
	source "$command_file"
	return 0
}

has_command() {
	type $1 >/dev/null 2>/dev/null
}

check_mandatory_command() {
	local command_name=$1

	if ! has_command $command_name; then
		v "Missing mandatory sysupgrade command '$command_name'"
		return 1
	fi

	return 0
}

call_sysupgrade_command() {
	local command_name=$1
	shift

	if has_command $command_name; then
		$command_name "$@" || return 1
	fi

	return 0
}

firmware_check_format() {
	. /usr/share/libubox/jshn.sh

	json_load "$(cat $1)" || {
		v "Invalid image metadata"
		return 1
	}

	# Get image format version
	json_get_vars format_version || return 1
	# Get compatible BOS mode
	json_get_vars bos_mode

	json_load "$(cat /etc/fw_info.json)" || {
		v "Invalid firmware info"
		return 1
	}

	if [ "$bos_mode" != "$(bos_mode)" ]; then
		v "Image can be used only in '$bos_mode' mode"
		return 1
	fi

	json_select supported_formats || return 1

	json_get_keys format_keys
	for k in $format_keys; do
		json_get_var supported_format "$k"
		[ "$format_version" = "$supported_format" ] && return 0
	done

	v "Image format '$format_version' not supported by this firmware"
	echo -n "Supported formats:"
	for k in $format_keys; do
		json_get_var supported_format "$k"
		echo -n " $supported_format"
	done
	echo
}

platform_check_image() {
	. /lib/functions/bos-defaults.sh

	local sysupgrade_meta_path="/tmp/sysupgrade.meta"

	if [ ! -f "$sysupgrade_meta_path" ]; then
		v "Image metadata file '$sysupgrade_meta_path' is missing"
		return 1
	fi

	firmware_check_format "$sysupgrade_meta_path" || return 1

	source_sysupgrade_command "$@" || return 1
	check_mandatory_command "package_do_upgrade" || return 1

	call_sysupgrade_command "package_check_image" "$@"
}

platform_pre_upgrade() {
	. /lib/functions/bos-defaults.sh

	# Preserve BOS essential files in ramfs
	export RAMFS_COPY_DATA="$RAMFS_COPY_DATA $BOS_BUILD_PATH"
	export RAMFS_COPY_DATA="$RAMFS_COPY_DATA $BOS_MAJOR_PATH"
	export RAMFS_COPY_DATA="$RAMFS_COPY_DATA $BOS_MODE_PATH"
	export RAMFS_COPY_DATA="$RAMFS_COPY_DATA $BOS_PLATFORM_PATH"
	export RAMFS_COPY_DATA="$RAMFS_COPY_DATA $BOS_VERSION_PATH"

	source_sysupgrade_command "$@" || return 1
	if ! call_sysupgrade_command "package_pre_upgrade" "$@"; then
		v "package_pre_upgrade: FAILED"
	fi
}

platform_switch_to_ramfs_required() {
	. /lib/functions/bos-defaults.sh

	source_sysupgrade_command "$@" || {
		echo "yes"
		return 1
	}
	if has_command "package_switch_to_ramfs_required"; then
		package_switch_to_ramfs_required "$@"
	else
		echo "yes"
	fi

	return 0
}

platform_do_upgrade() {
	. /lib/functions/bos-defaults.sh

	export PLATFORM_DO_UPGRADE_RESULT="err"

	source_sysupgrade_command "$@" || return
	flush_all
	if ! call_sysupgrade_command "package_do_upgrade" "$@"; then
		v "package_do_upgrade: FAILED"
		return
	fi
	[ -n "$UPGRADE_BACKUP" ] || platform_finish_upgrade

	export PLATFORM_DO_UPGRADE_RESULT="ok"
}

platform_copy_config() {
	. /lib/functions/bos-defaults.sh

	[ "$PLATFORM_DO_UPGRADE_RESULT" == "ok" ] || return

	flush_all
	if ! call_sysupgrade_command "package_copy_config"; then
		v "package_copy_config: FAILED"
	fi

	platform_finish_upgrade
}

platform_finish_upgrade() {
	flush_all
	if ! call_sysupgrade_command "package_finish_upgrade"; then
		v "package_finish_upgrade: FAILED"
	fi
	flush_all
}
