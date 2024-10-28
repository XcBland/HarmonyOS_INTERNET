import { Category, Food } from '../entity/FoodAndCategory';
import FoodItemComp from './FoodItemComp';
import NavComp from './NavComp';

@Component
struct MainComp {
  @Prop list: Category[] //父传子，Category数组
  @State activeIndex: number = 0 //当前选中的分类索引

  build() {
    Column({ space: 20 }) {

      //头部组件
      NavComp()
      //内容区域
      Row({ space: 10 }) {
        //左边
        Column({ space: 5 }) {
          ForEach(this.list, (item: Category, index: number) => {
            Text(item.name)
              .onClick(() => {
                this.activeIndex = index      //根据选中的分类索引更新当前选中状态
              })
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 10, bottom: 10 })
              .backgroundColor(this.activeIndex === index ? '#fff' : '#f1f3f5')
          })
        }.width('30%')

        //右边
        List({ space: 5 }) {
          //[注意]
          //     默认加载组件时,遍历就会执行,这时@Prop list为空数组,导致报错
          //     要等待异步数据加载完毕后父组件传址给子组件,才会正常显示
          ForEach(this.list[this.activeIndex]?.foods, (item: Food, index: number) => {
            ListItem() {
              FoodItemComp({ item: item })
            }
          })


        }
        .height('100%')
        .width('70%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Top)

    }
    .backgroundColor('#f1f3f5')
    .width('100%')
    .height('100%')
  }
}

export default MainComp;