#!/bin/bash

# 输入待加密的字符串
read -p "Enter the string to encode: " input_string

# 对输入字符串进行base64编码
encoded_string=$(echo -n $input_string | base64)

echo "Encoded string: $encoded_string"