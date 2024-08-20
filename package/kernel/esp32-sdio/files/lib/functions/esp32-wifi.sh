#!/bin/sh

WIFI_BOOT_PIN_TIMEOUT=1

reboot_esp() {
    # The WIFI_RESET must be hold for some time so that ESP notices that
    # but it must be shorter than the WIFI_BOOT_PIN_TIMEOUT above.
    gpioset --mode=time --usec 10 $(gpiofind WIFI_RESET)=1
    gpioset $(gpiofind WIFI_RESET)=0
}

reboot_esp_to_bl() {
    gpioset --mode=time --sec $WIFI_BOOT_PIN_TIMEOUT --background $(gpiofind WIFI_BOOT)=1
    reboot_esp
}

reboot_esp_to_app() {
    gpioset --mode=time --sec $WIFI_BOOT_PIN_TIMEOUT --background $(gpiofind WIFI_BOOT)=0
    reboot_esp
}

flash_firmware() {
    local FW_PATH="$1"
    local UART_PATH="/dev/ttySTM2"
    local UART_SPEED="4000000"

    /usr/bin/espflash -p "$UART_PATH" \
                      -s "$UART_SPEED" \
                      -l "$FW_PATH/bootloader.bin" \
                      -a "$FW_PATH/network_adapter.bin" \
                      -t "$FW_PATH/partition-table.bin" \
                      -o "$FW_PATH/ota_data_initial.bin"
}

flash_fg_firmware() {
    reboot_esp_to_bl
    flash_firmware "/lib/firmware/esp32c6/sdio/fg"
    reboot_esp_to_app
}

flash_ng_firmware() {
    reboot_esp_to_bl
    flash_firmware "/lib/firmware/esp32c6/sdio/ng"
    reboot_esp_to_app
}

start_wifi_ap() {
    esp32-sdio-cli softap_start "$1"
    ifup wifi-ap
}

stop_wifi_ap() {
    esp32-sdio-cli softap_stop
    ifdown wifi-ap
}
