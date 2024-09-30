#!/bin/bash

# 设置变量
SOURCE_REPO_URL="https://github.com/Aethersailor/Custom_OpenClash_Rules.git"
TARGET_REPO_URL="github.com/hyprocritor/Custom_OpenClash_Rules.git"
SOURCE_DIR="Custom_OpenClash_Rules"
TARGET_DIR="custom_clash_rule_hyprocritor"
CFG_FILE="$SOURCE_DIR/cfg/Custom_Clash.ini"
REMOVE_NODES=("🇨🇦 加拿大节点" "🇬🇧 英国节点" "🇫🇷 法国节点" "🇩🇪 德国节点" "🇳🇱 荷兰节点" "🇹🇷 土耳其节点" "🇻🇳 越南节点")

# 克隆源仓库
if [ -d "$SOURCE_DIR" ]; then
#    echo "Directory $SOURCE_DIR already exists. Pulling latest changes..."
    cd "$SOURCE_DIR" && git pull origin main && cd ..
else
    echo "Cloning source repository..."
    echo $GITHUB_TOKEN
    git clone ${SOURCE_REPO_URL}
fi

# 检查配置文件是否存在
if [ ! -f "$CFG_FILE" ]; then
    echo "Configuration file not found: $CFG_FILE"
    exit 1
fi

# 删除以指定节点开头的行
echo "Removing lines starting with specific proxy groups..."
for node in "${REMOVE_NODES[@]}"; do
  sed -i "/custom_proxy_group=${node}/d" "$CFG_FILE"
done

# 替换文件中其他行的这些节点为空
echo "Replacing specified nodes in remaining lines..."
for node in "${REMOVE_NODES[@]}"; do
  sed -i "s/${node}\`\[\]//g" "$CFG_FILE"
done

echo "Source repository processing completed."

# 克隆目标仓库
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Pulling latest changes..."
    cd "$TARGET_DIR" && git pull origin latest && cd ..
else
    echo "Cloning target repository..."
    git clone https://${GITHUB_TOKEN}@$TARGET_REPO_URL $TARGET_DIR
fi

# 将修改后的文件复制到目标仓库
cp "$CFG_FILE" "$TARGET_DIR/cfg/"


