class_name CardData
extends Resource

## 名稱
@export var show_name:String

## 正面圖片
@export var front_image:Texture2D
## 背面圖片
@export var back_image:Texture2D = load("uid://cm2bxk4uku4cl")

## 敘述
@export_multiline var description:String
## 左邊描述
@export_multiline var left_desc:String
## 右邊描述
@export_multiline var right_desc:String

## 解鎖條件
@export var limit:String
