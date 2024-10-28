/**
 * 餐品类型
 */
export class Food {
  id: number = 0               // 餐品ID
  name: string = ''            // 餐品名称
  like_ratio_desc: string = '' // 点赞率描述
  month_saled: number = 0      // 月售数量
  unit: string = ''            // 单位
  food_tag_list: string[] = [] // 餐品标签列表
  price: number = 0            // 餐品价格
  picture: string = ''         // 餐品图片
  description: string = ''     // 餐品描述
  tag: string = ''             // 餐品标签
  count: number = 0            // 餐品数量
}

/**
 * 餐品分类
 */
export class Category {
  tag: string = '' // 餐品分类标签
  name: string = '' // 餐品分类名称
  foods: Food[] = [] // 餐品列表
}