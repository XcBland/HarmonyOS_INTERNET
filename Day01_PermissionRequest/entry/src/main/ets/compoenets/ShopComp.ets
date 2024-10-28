import { ShopInfo } from '../model/ShopInfo'

@Component
export struct ShopComp {
  @Prop item: ShopInfo

  build() {
    Column({ space: 20 }) {
      Text(`排行第 ${this.item.id} 名`)
        .fontSize(20)
      Text(this.item.name.split('（')[0])
        .fontSize(16)
      Row(){
        ForEach(this.item.images, (url:string, index:number) => {
          Image(url)
            .height(150)
            .width('48%')
            .borderRadius(20)
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Text(this.item.area)
        .fontSize(14)
      Text(this.item.address)
        .fontSize(14)
      Row(){
        Row(){
          Text(`${this.item.score}/分`)
            .fontSize(14)
          Text(`${this.item.comments}条评论`)
            .fontSize(14)
        }
        .width('40%')
        .justifyContent(FlexAlign.SpaceBetween)
        Blank()
        Text(`${this.item.avgPrice}元/人`)
          .fontSize(14)
      }.width('100%')

      Text(`营业时间:${this.item.openHours}`)
        .fontSize(14)
    }

    .width('90%')

  }
}