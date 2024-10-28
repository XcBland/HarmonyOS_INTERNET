//[购物车模块]

import { CartItem } from "../entity/CartItem";
import PreHelper from "../utils/PreHelper";

/**
 * 购物车功能模块
 */
export class CartModel {
  private static instance:CartModel
  private preHelper:PreHelper = PreHelper.getInstance('cart')
  private constructor() {}
  static getInstance():CartModel{
      if(!CartModel.instance){
          CartModel.instance = new CartModel()
      }
      return CartModel.instance
  }

  /**
   * 获取购物车列表
   * @returns  Promise<CartItem[]>|[]
   */
  async getCartList():Promise<CartItem[]>{
    const res = await this.preHelper.get('list')
    //undefined 或者 null 或 '' 或 0 默认都是false, 所以返回[]
    return res? JSON.parse(res) as CartItem[] : []
  }


  /**
   * 保存购物车列表
   * @param cartList 购物车列表数组
   * @returns  Promise<void>
   */
  async saveCart(cartList:CartItem[]){
    await this.preHelper.set('list',JSON.stringify(cartList))
  }


  /**
   * 清空购物车列表
   */
  async clearCart(){
    await this.preHelper.remove('list')
  }



}

