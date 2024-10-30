#!/bin/sh

. /lib/functions/bos-factory-default.sh
. /lib/functions/bos-defaults.sh

if is_factory_default; then
    disable_captive_portal
    unset_factory_default

    echo "Rebooting to user-configured mode"
    reboot
else
    echo "Not in factory default mode"
fi
