import { Food } from "./FoodAndCategory"

/**
 * 购物车中的商品项
 */
export class CartItem {
  food:Partial<Food> = {}       //通过泛型Partial<Food>来定义food的部分属性，这样可以让CartItem实例化时，只传入部分属性，而不用传入全部属性
  count:number = 1              //购物车中某个商品的数量

}