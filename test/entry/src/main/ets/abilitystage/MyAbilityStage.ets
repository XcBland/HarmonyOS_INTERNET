import AbilityStage from "@ohos.app.ability.AbilityStage";
import Want from "@ohos.app.ability.Want";


//必须作为默认模块导出,系统需要自动导入使用的:名称自定义,必须有default
//必须继承于AbilityStage,作为它的子类,对应对象的关系和满足约束类型
//父类中的方法,系统会自动调用
export default class MyAbilityStage extends AbilityStage {
  //[重写父类方法]
  // 当获取到want的时候执行,父类方法中的代码不适用
  // 这里重写,覆盖父类方法的代码
  // 生成唯一的key给当前的UIAbility,用于标识当前的UIAbility
  onAcceptWant(want: Want): string {
    if(want.abilityName === 'Docability'){
      const params = want.parameters as Record<string, string>;
      //自定义代码,返回字符串
      //传入:id_1   id_2
      //返回:Docability_id_1,Docability_id_2
      if(params){
        return`Docability_${params.key}`
      }
    }
    return 'MyAbilityStage'
  }
}