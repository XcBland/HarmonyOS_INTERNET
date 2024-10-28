import AbilityStage from "@ohos.app.ability.AbilityStage";
import Want from "@ohos.app.ability.Want";

export default class MyAbilityStage extends AbilityStage {

  onAcceptWant(want: Want): string {
    if(want.abilityName === 'DoctorAbility'){

      if(want.parameters){
        return `DoctorAbility_${want.parameters.key}`
      }

    }
    return '';
  }

}