import { fileIo as fs } from '@kit.CoreFileKit'
import { request } from '@kit.BasicServicesKit'
import { IconType, promptAction } from '@kit.ArkUI'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@Entry
@Component
struct UpDownFile {
  //[权限申请]:需要网络权限，用于上传文件到服务器
  //http://122.51.240.24:31001/upload
  //http://122.51.240.24:31001/view/

  @State imgUrl: string = ''
  //[上传文件]
  async uploadFile(fileName: string) {
    //第一步:将本地文件放入沙箱的缓存cache/目录下
    //目的:
    //    1.internet协议会自动获取沙箱路径,不能获取本地路径
    //    2.catch/缓存,更好的保护系统,而且可以清空缓存,无需再应用中保留
    //  获取沙箱路径
    const cacheDir = getContext(this).cacheDir
    //  新建一个文件目标
    const file = fs.openSync(`${cacheDir}/${fileName}`, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
    //  读取本地文件内容
    const buff = await getContext(this).resourceManager.getRawFileContent(fileName)
    //  写入
    const num = fs.writeSync(file.fd, buff.buffer)

    //关闭
    fs.close(file.fd)

    //第二步:定义上传的配置
    const uploadConfig: request.UploadConfig = {
      url: 'http://122.51.240.24:31001/upload',            //上传地址
      method: 'POST',                                      //上传方法
      header: {
        //请求头
        'Accept': '*/*',                                    //可接受的内容类型(跨域请求),任何路径都可以访问
        'Content-Type': 'multipart/form-data',              //请求体类型 : 多文件/数据提交||application/json||/x-www-form-data
      },
      files: [//上传文件数组
        {
          filename: fileName,                               //文件原始名称
          name: 'file',                                     //服务器接收,提取数据的名称
          uri: `internal://cache/${fileName}`,              //文件路径:沙箱路径
          type: '.mp4'                                      //文件类型:
        }
      ],
      data: []                                               //请求参数数组
    }
    //第三步:上传文件
    try{
      //同步:执行上传的操作,得到一个上传的Task任务线程
      const uploadTask = await request.uploadFile(getContext(this), uploadConfig)
      uploadTask.on('complete',(res)=>{
        if(res[0].responseCode === 0){
          promptAction.showToast({message: '上传成功'})
          this.imgUrl = 'http://122.51.240.24:31001/view/'+fileName
        }else{
          promptAction.showToast({message: '上传失败'})
          console.error('上传失败:', res)
        }
      })
      uploadTask.on('progress', (progress) => {
        promptAction.showDialog({ message: '上传:'+ progress.toFixed(2) + '%' })
      })

    }catch(e){
      console.error(JSON.stringify(e))
    }
  }

  //[下载文件:沙箱]
  downloadToApp() {
    //可选:本地如果已有文件,删除掉
    const filesPath = getContext(this).filesDir+'/1.png'
    if(fs.accessSync(filesPath)){
      fs.unlinkSync(filesPath)
    }

    //下载文件异步
    request.downloadFile(getContext(this),{
      url: 'http://122.51.240.24:31001/view/1.png',
      filePath:filesPath
    },(err,downloadTask)=>{
      if(err) {
        console.error(JSON.stringify(err))
        promptAction.showToast({ message: '下载失败' })
      }
      //监听
      downloadTask.on('progress', (progress) => {
          promptAction.showDialog({ message: '下载:'+ progress.toFixed(2) + '%' })
      })
      downloadTask.on('complete',()=>{
        this.imgUrl = 'file://'+filesPath
      })
    })

  }


  build() {
    Column({ space: 20 }) {
      Button('上传文件')
        .onClick(() => {
          this.uploadFile('ins01.png')
        })

      Button('下载文件:沙箱')
        .onClick(() => {
          this.downloadToApp()
        })


      //下载到相册
      SaveButton({
        icon:SaveIconStyle.FULL_FILLED,       //图标类型:全填充
        text: SaveDescription.SAVE_IMAGE,     //按钮描述:保存图片
        buttonType:ButtonType.Normal          //按钮类型:常规
      })
        //点击事件,安全按钮会传入第二个参数:isGranted,代表是否允许
        .onClick(async (event,isGranted:SaveButtonOnClickResult) => {
          //安全按钮会弹出系统提示框,提供当前此次临时的运行访问授权
          //是否允许
          if(isGranted === SaveButtonOnClickResult.SUCCESS){
            //用户允许,执行下载操作:'http://122.51.240.24:31001/view/1.png'
            const context = getContext(this)     //获取应用上下文
            const filesDir = context.filesDir    //获取本地路径
            const fileName = '1.png'             //文件名称
            if(fs.accessSync(`${filesDir}/${fileName}`)){
              //本地已有文件,删除掉
              fs.unlinkSync(`${filesDir}/${fileName}`)
            }
            const downloadTask:request.DownloadTask = await request.downloadFile(
              context,
              {
                url:'http://122.51.240.24:31001/view/'+fileName,
                filePath: `${filesDir}/${fileName}`
              }
            )

            //监听下载进度
            downloadTask.on('complete', async ()=>{
              //下载完成,保存到相册
              try{
                //Next提供的简易操作,相册权限帮助工具
                const photoHelper = photoAccessHelper.getPhotoAccessHelper(context)
                //已下载的图片路径位置
                const fileUri = `${filesDir}/${fileName}`
                ///创建图片资源请求对象
                const assetImage = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(
                  context,fileUri
                )
                //执行保存操作
                await photoHelper.applyChanges(assetImage)
                //提示保存成功
                promptAction.showToast({ message: '保存成功' })
              }catch(e){
                console.error('UpDownFile:assetImage:'+JSON.stringify(e))
              }
            })

          }else{
            //不允许,弹出提示框
            promptAction.showDialog({ message: '请先允许应用访问相册' })
          }
        })

      //预览效果:验证下载是否成功
      // Image(this.imgUrl)
      //   .width(200)
      //   .height(200)


    }
    .backgroundImage(this.imgUrl)
    .backgroundImageSize(ImageSize.Cover)
    .width('100%')
    .height('100%')

  }
}