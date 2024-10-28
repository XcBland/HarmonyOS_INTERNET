import { CartItem } from '../entity/CartItem';
import { Food } from '../entity/FoodAndCategory';
import { CartModel } from '../model/CartModel';

@Component
export default struct AddCartComp {
  //状态
  @Consume @Watch('getIndex') cartList: CartItem[] //购物车列表
  //属性
  food: Partial<Food> = {}; //当前食物
  index: number = -1; //当前食物索引

  private cartModel:CartModel = CartModel.getInstance() //购物车管理器


  //获取购买数量，可以知道是否曾购买过
  getCount(): number {
    //系统方法，查找返回元素
    //方法自动遍历每一个元素，提取，执行后面的箭头函数
    //箭头函数返回true，方法返回当前元素，返回false的时候，跳过下一个
    return this.cartList.find((item: CartItem, index) => {
      if (item.food.id === this.food.id) {
        this.index = index //记录当前食物索引
        return true //找到了，返回true
      }
      return false //没找到，返回false
    })?.count || 0
    //当方法执行完毕
    //如果找到了，则返回当前元素的数量
    //如果没有找到，则返回0
  }

  //获取索引
  getIndex(){
    this.index = this.cartList.findIndex( item =>{
      return item.food.id === this.food.id
    })
  }

  //添加购物车
  async addCart(): Promise<void> {
    //到数组里找对应的商品有没有 ？id === this.food.id
    //有：更新数量
    //没有：+1个
    //更新数组

    //购物车内是否已经有该食物
    if(this.index === -1) {
      //没有，则添加
      this.cartList.push({ food: this.food, count: 1 })
      //更新索引
      //获取最后一个元素的索引
      this.index = this.cartList.length - 1
    }else{
      //有：更新数量
      this.cartList[this.index].count++
      //装填管理，监听不到元素内部的改变，需要更新整个数组的地址
      this.cartList = [...this.cartList]
    }
    await this.cartModel.saveCart(this.cartList)
  }

  //减少购物车
  async reduceCart():Promise<void> {
    //判断是否有该食物
    if(this.index === -1) {
      //没有，则不操作
      return
    }
    //有：数量减1
    this.cartList[this.index].count--
    //数量为0，则删除
    if(this.cartList[this.index].count === 0) {
      this.cartList.splice(this.index, 1)
      //更新索引
      this.index = -1
    }
    //装填管理，监听不到元素内部的改变，需要更新整个数组的地址
    this.cartList = [...this.cartList]
    await this.cartModel.saveCart(this.cartList)
  //   if(this.cartList[this.index].count===0){
  //     //调用删除元素方法，指定索引，删一个
  //     //方法会重新得到一个新的数组，他的内存地址可以改变
  //     this.cartList.splice(this.index,1)
  //     //更新索引
  //     this.index = -1
  //   }else{
  //     this.cartList[this.index].count--
  //     this.cartList = [...this.cartList]
  //   }
  //   await this.cartModel.saveCart(this.cartList)
 }

  build() {
    Row() {
      //判断是否显示
      if (this.getCount()) {
        //扣除数量
        Text('-').textStyle()
          .onClick(() => {
            this.reduceCart()
          })
        //显示数量
        Text(`${this.getCount().toString()}`)
          .fontSize(16)
          .width(15)
          .textAlign(TextAlign.Center)
      }
      //添加
      Text('+')
        .textStyle()
        .onClick(() => {
          this.addCart()
        })
    }
    .padding(10)
    .alignItems(VerticalAlign.Top)

  }
}

//组件扩展
//系统组件在设置的时候，鸿蒙允许继承扩展，可以自定义组件样式
@Extend(Text)
function textStyle() {
  .backgroundColor('#f78e03')
  .padding({ left: 5, right: 5 })
  .borderRadius(2)
}