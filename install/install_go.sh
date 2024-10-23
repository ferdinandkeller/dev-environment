#!/bin/bash

# define installation folder
dest_folder="$HOME/.local/bin"
echo "golang will be installed at $dest_folder"

# get the current architecture
arch=$(dpkg --print-architecture)
echo "targeting $arch architecture"

# find the latest's version url
partial_url=$(curl -s "https://go.dev/dl/" | grep -oP "/dl/go[1-9\.]+\.linux-$arch.tar.gz" | sort -V | tail -n 1)
full_url="https://go.dev${partial_url}"
echo "downloading $full_url"

# download the file
wget -q $full_url -O /tmp/go.tar.gz
echo "downloading done"

# untar the file
tar -xzf /tmp/go.tar.gz -C /tmp
echo "decompression done"

# uninstall current go version
rm -rf $dest_folder/go
echo "removing older version done"

# replace install
mkdir -p $dest_folder
mv /tmp/go $dest_folder
echo "installation done"

# add path to $HOME/.profile (if not already there)
new_path="PATH=\"$dest_folder/go/bin:\$PATH\""
(cat $HOME/.profile | grep -x $new_path) || echo "\n$new_path" >> $HOME/.profile

# source the updated file
echo "Please run 'source $HOME/.profile' to update your environment variables."

# clean /tmp
rm -r /tmp/go.tar.gz
echo "cleaning done"