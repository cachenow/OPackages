#!/bin/bash

# 配置文件路径
config_file=./.config

# 软件包目录路径
package_dir=./kiddin9-packages

# 保存删除的软件包列表文件路径
deleted_packages_file=./deleted_packages.txt

# 保存保留的软件包列表文件路径
kept_packages_file=./kept_packages.txt

# 从 config 文件中提取所有被注释掉的软件包（即包含 `# CONFIG_PACKAGE_` 和 `is not set` 的行）
commented_packages=$(grep -E "^# CONFIG_PACKAGE_.+is not set$" "$config_file" | cut -d" " -f2)

# 从 config 文件中提取所有被标注为 `=y` 的软件包（即包含 `CONFIG_PACKAGE_` 和 `=y` 的行）
enabled_packages=$(grep -E "^CONFIG_PACKAGE_.+=y$" "$config_file" | cut -d"=" -f1 | sed 's/^CONFIG_PACKAGE_//')

# 将两个列表合并，并去重
packages_to_keep=$(echo "$commented_packages"$'\n'"$enabled_packages" | sort | uniq | grep -E "^[^#].*=y$" | cut -d"=" -f1)

# 遍历合并后的列表，对于每个软件包，如果它被标注为 `=y`，则保留它的源码；否则，删除它的源码
for dir in $(ls "$package_dir"); do
  if echo "$packages_to_keep" | grep -q "^$dir$"; then
    echo "Keeping $dir"
    echo "$dir" >> "$kept_packages_file"
  else
    echo "Deleting $dir"
    echo "$dir" >> "$deleted_packages_file"
    rm -rf "$package_dir/$dir"
  fi
done
