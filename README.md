# NanoPi Neo 镜像构建

本项目为 NanoPi Neo 构建支持 USB OTG 功能的 Armbian 镜像。

## 功能特性

- **USB OTG 支持**: USB OTG 端口配置为 peripheral 模式 (`dr_mode=peripheral`)
- **libcomposite 模块**: 启用 USB gadget 功能
- **Debian Bookworm**: 基于最新稳定版 Debian 发行版

## 项目结构

```
.
├── .github/
│   └── workflows/
│       └── build-nanopi-neo.yml   # GitHub Actions 工作流
├── config/
│   └── boards/
│       └── nanopineo.csc          # 包含 libcomposite 模块的板卡配置
└── patch/
    └── kernel/
        └── archive/
            └── sunxi-6.18/
                └── patches.armbian/
                    └── arm-dts-h3-nanopi-neo-set-usb-otg-peripheral.patch
```

## 使用 GitHub Actions 构建

每次推送到 `main` 分支时会自动构建镜像。您也可以通过 GitHub 的 "Actions" 标签页手动触发构建。

### 前置条件

1. 将此仓库 Fork 到您的 GitHub 账户
2. 在 Fork 的仓库中启用 GitHub Actions

### 构建流程

1. **检出代码**: 工作流会检出本仓库和上游 `armbian/build` 仓库
2. **应用补丁**: 将自定义补丁复制并应用到构建系统
3. **构建镜像**: Armbian 构建系统编译镜像
4. **压缩镜像**: 使用 xz 压缩生成的镜像文件
5. **发布 Release**: 将压缩后的镜像上传到 GitHub Release

## 本地构建

要在本地构建，请按照以下步骤操作：

```bash
# 克隆 armbian/build 仓库
git clone https://github.com/armbian/build.git

# 复制补丁和配置文件
cp -r patch/kernel/archive/sunxi-6.18/patches.armbian/* build/patch/kernel/archive/sunxi-6.18/patches.armbian/
cp config/boards/nanopineo.csc build/config/boards/nanopineo.csc

# 如果补丁尚未添加到 series.conf，则添加
if ! grep -q "arm-dts-h3-nanopi-neo-set-usb-otg-peripheral" build/patch/kernel/archive/sunxi-6.18/series.conf; then
  sed -i '/arm-dts-h3-nanopi-neo-Add-regulator-leds-mmc2.patch/a \	patches.armbian/arm-dts-h3-nanopi-neo-set-usb-otg-peripheral.patch' build/patch/kernel/archive/sunxi-6.18/series.conf
fi

# 运行构建
cd build
./compile.sh build BOARD=nanopineo BRANCH=current BUILD_MINIMAL=no KERNEL_CONFIGURE=no RELEASE=bookworm KERNEL_GIT=shallow
```

## 输出文件

构建的镜像文件位于：
```
build/output/images/Armbian-unofficial_*-Nanopineo_bookworm_current_*.img
```

## 烧录镜像

使用 `dd` 或 `balenaEtcher` 将镜像烧录到 SD 卡：

```bash
# 使用 dd（将 /dev/sdX 替换为您的 SD 卡设备）
xzcat Armbian-unofficial_*-Nanopineo_bookworm_current_*.img.xz | sudo dd of=/dev/sdX bs=4M status=progress
```

## USB OTG 使用方法

镜像烧录完成并启动 NanoPi Neo 后，您可以将 USB OTG 端口用作 USB gadget。`libcomposite` 模块会自动加载。

## 许可证

本项目基于 [Armbian 构建系统](https://github.com/armbian/build)，采用 GPL-2.0 许可证。

## 致谢

- [Armbian](https://www.armbian.com/) 提供构建系统
- FriendlyARM 提供 NanoPi Neo 硬件