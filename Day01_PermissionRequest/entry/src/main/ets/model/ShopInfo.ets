//数据模型
//   提供类型约束，只有数据，推荐：interface
export interface ShopInfo {
  "id": number,
  "name": string,
  "images": string[],
  "area": string,
  "address": string,
  "avgPrice": number,
  "comments": number,
  "score": number,
  "openHours": string
}