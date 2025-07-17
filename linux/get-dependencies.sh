#!/bin/sh

set -eux

sed -i 's/DownloadUser/#DownloadUser/g' /etc/pacman.conf

if [ "$(uname -m)" = 'x86_64' ]; then
		PKG_TYPE='x86_64.pkg.tar.zst'
else
		PKG_TYPE='aarch64.pkg.tar.xz'
fi

LLVM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/llvm-libs-nano-$PKG_TYPE"
FFMPEG_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/ffmpeg-mini-$PKG_TYPE"
QT6_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/qt6-base-iculess-$PKG_TYPE"
LIBXML_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/libxml2-iculess-$PKG_TYPE"
OPUS_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/opus-nano-$PKG_TYPE"
MESA_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/mesa-mini-$PKG_TYPE"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
		base-devel \
		boost \
		boost-libs \
		cmake \
		curl \
		enet \
		fmt \
		gamemode \
		git \
		inetutils \
		jq \
		nasm \
		ninja \
		nlohmann-json \
		patchelf \
		python-pip \
		qt6-tools \
		qt6-wayland \
		sdl2 \
		spirv-headers \
		strace \
		unzip \
		vulkan-headers \
		vulkan-mesa-layers \
		vulkan-nouveau \
		vulkan-radeon \
		wget \
		wireless_tools \
		xcb-util-cursor \
		xcb-util-image \
		xcb-util-renderutil \
		xcb-util-wm \
		xorg-server-xvfb \
		zip \
		zsync

if [ "$(uname -m)" = 'x86_64' ]; then
		pacman -Syu --noconfirm vulkan-intel haskell-gnutls svt-av1
else
		pacman -Syu --noconfirm vulkan-freedreno vulkan-panfrost
fi


echo "Installing debloated pckages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$LLVM_URL"   -O  ./llvm-libs.pkg.tar.zst
wget --retry-connrefused --tries=30 "$QT6_URL"    -O  ./qt6-base-iculess.pkg.tar.zst
wget --retry-connrefused --tries=30 "$LIBXML_URL" -O  ./libxml2-iculess.pkg.tar.zst
wget --retry-connrefused --tries=30 "$OPUS_URL"   -O  ./opus-nano.pkg.tar.zst

pacman -U --noconfirm ./*.pkg.tar.zst
rm -f ./*.pkg.tar.zst

echo "All done!"
echo "---------------------------------------------------------------"
