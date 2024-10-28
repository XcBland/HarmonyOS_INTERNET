/**
 * @Auhtor DLY
 *
 */

import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit'
import { router } from '@kit.ArkUI'

@Entry
@Component

struct Index {

  @State fileList: string[] = []
  @State imgURL: string = ''

  //resource/rawfile/文件
  //当前应用的本地资源文件目录，可以存放一些图片、音频、视频等资源文件。
  //放入一些图片资源便于操作
  //[文件读写操作:rawfile/读取,写入沙箱指定的位置]
  async writeFile(){
    try{
      //第一步:获取应用文件的沙箱路径
      const context = getContext(this)
      const filesDir = context.filesDir
      console.info('The filesDir is: '+filesDir)
      //第二步:创建并打开文件:[文件读写操作:rawfile/读取,写入沙箱指定的位置]
      //同步方法('文件路径',操作类型)
      //操作类型:创建文件|读写文件
      const file = fs.openSync(`${filesDir}/ins01.png`, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      console.info('The file is: '+JSON.stringify(file.fd))
      // 第三步:读取本地文件
      const buff = await context.resourceManager.getRawFileContent(`ins01.png`)
      console.info('The buff is: '+buff.length)
      // 第四步:写入沙箱文件
      const num = fs.writeSync(file.fd, buff.buffer)
      console.info('The num is: '+num)
      // 第五步:关闭文件[重要]
      fs.closeSync(file.fd)

    }catch(e){
      console.error('writeFile error: '+JSON.stringify(e))
    }
  }

  /**
   * 获取沙箱文件列表
   */
  async getFileList(){
    try{
      //第一步:获取应用文件的沙箱路径
      const context = getContext(this)
      const filesDir = context.filesDir
      //第二步:获取沙箱文件列表
      // this.fileList = fs.listFileSync(filesDir)(所有文件)
      //追加第二个选项参数,可以筛选文件
      this.fileList = fs.listFileSync(filesDir, {
        // recursion: true, //是否递归遍历
        filter:{
          suffix: ['.png', '.jpg','.txt'], //指定文件后缀
          fileSizeOver: 0, //指定文件大小>=0
          lastModifiedAfter: new Date(0).getTime(), //指定文件最后修改时间>=指定时间
        }
      })
      //第三步:打印沙箱文件列表

    }catch(e){
      console.error('getFile error: '+JSON.stringify(e))
    }
  }

  //[打开对应文件]
  async openFile(filePath:string){
    try{
      //第一步:获取应用文件的沙箱路径
      const fileDir = getContext(this).filesDir
      //Image支持沙箱路径的,但是路径前面需要加前缀 file://
      //再加上沙箱路径
      this.imgURL = `file://${fileDir}/${filePath}`
      console.info('The imgURL is: '+this.imgURL)
    }catch(e){
      console.error('openFile error: '+JSON.stringify(e))
    }
  }




  build() {
    Column({space:30}) {

      Button('图片存入->沙箱')
        .onClick(()=>{
          this.writeFile()
        })

      Button('获取沙箱-文件列表')
        .onClick(()=>{
          this.getFileList()
        })
      Column({space:10}){
        ForEach(this.fileList, (item:string, index) => {
          Text(item)
            .fontSize(30)
            .fontColor('#f00')
            .onClick(()=>{
              //打开文件
              this.openFile(item)
            })
        })
      }.borderWidth(1).alignItems(HorizontalAlign.Start)


      Button('跳转到上传文件页面')
        .onClick(()=>{
          router.pushUrl({url:'pages/UpDownFile'})
        })


      // Image(this.imgURL)
      //   .width('100')
      //   .height('100')
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundImage(this.imgURL)
    .backgroundImageSize(ImageSize.Cover)
    
  }

}


