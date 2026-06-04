# Allwinner H3 quad core 256/512MB RAM SoC headless
BOARD_NAME="NanoPi Neo"
BOARD_VENDOR="friendlyelec"
BOARDFAMILY="sun8i"
BOARD_MAINTAINER="spendist"
INTRODUCED="2016"
BOOTCONFIG="nanopi_neo_defconfig"
MODULES="g_serial libcomposite"
MODULES_BLACKLIST="lima"
DEFAULT_OVERLAYS="usbhost1 usbhost2"
DEFAULT_CONSOLE="serial"
SERIALCON="ttyS0,ttyGS0"
HAS_VIDEO_OUTPUT="no"
KERNEL_TARGET="current,edge,legacy"
KERNEL_TEST_TARGET="current"

function post_family_config__nanopineo_extra_packages() {
	display_alert "Setting up extra packages for ${BOARD}" "${RELEASE}" "info"
	add_packages_to_image "docker.io" "containerd" "docker-compose"
}
