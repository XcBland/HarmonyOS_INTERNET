import { fileIo as fs } from '@kit.CoreFileKit'
import { request } from '@kit.BasicServicesKit'

@Entry
@Component
struct Index02 {
  @State fileList:string[] = []
  @State filesDir:string = getContext(this).filesDir
  @State imgUrl:string = ''

  build() {
    Column(){
      Button('图片存入')
        .onClick(async ()=>{
          // const img = await image.createImageSource(imgArr.buffer).createPixelMap()

          const path = getContext(this).filesDir
          const imgArr = await getContext(this).resourceManager.getMediaContent($r('app.media.75924390_p0'))
          // const imgArr = await getContext(this).resourceManager.getRawFileContent('75924390_p0.png')
          const imgfile = fs.openSync(`${path}/75924390_p1.png`,fs.OpenMode.CREATE|fs.OpenMode.READ_WRITE)
          fs.write(imgfile.fd,imgArr.buffer)
            .then(()=>{
              console.log('ok')
            })
        })
      Button('获取沙箱文件列表')
        .onClick(async ()=>{

          fs.listFile(this.filesDir,{
            filter:{
              suffix:['.png'],
              fileSizeOver: 0
            }
          })
            .then(res=>{
              this.fileList = res
            })
            .catch((err:Error)=>{
              console.error('获取失败'+JSON.stringify(err))
            })
        })

      Button('上传图片')
        .onClick(async ()=>{
          const path = getContext(this).cacheDir
          const imgArr = await getContext(this).resourceManager.getMediaContent($r('app.media.75924390_p0'))
          // const imgArr = await getContext(this).resourceManager.getRawFileContent('startIcon.png')
          const imgfile = fs.openSync(`${path}/75924390_p0.png`,fs.OpenMode.CREATE|fs.OpenMode.READ_WRITE)
          await fs.write(imgfile.fd,imgArr.buffer)
          await fs.close(imgfile.fd)
          console.info('写入缓存完成')

          const uploadConfig:request.UploadConfig = {
            url: 'http://122.51.240.24:31001/upload',
            header: {
              'Accept':'*/*',
              'Content-Type':'multipart/form-data'
            },
            method: 'post',
            files: [
              {
                filename: '75924390_p0.png',
                name: 'file',
                uri: 'internal://cache/75924390_p0.png',
                type: '.png'
              }
            ],
            data:[]
          }
          try {
            const uploadTask = await request.uploadFile(getContext(this),uploadConfig)
            uploadTask.on("progress",(nowSize,allSize)=>{
              console.info(`进度为${nowSize}/${allSize}`)
              if (nowSize===allSize){
                this.imgUrl = 'http://122.51.240.24:31001/view/75924390_p0.png'
              }
            })
            uploadTask.on('complete',(res)=>{
              if (res[0].responseCode===0){
                AlertDialog.show({
                  message:'上传成功'+JSON.stringify(res)
                })
              }
            })
            uploadTask.on('fail',(err)=>{
              AlertDialog.show({
                message:'上传失败'+JSON.stringify(err)
              })
            })
          } catch (err) {
            console.error('上传失败'+JSON.stringify(err))
          }
        })

      Column({space:20}){
        ForEach(this.fileList,(item:string)=>{
          Text(item)
            .onClick(()=>{
              this.imgUrl = 'file://'+this.filesDir+'/'+item
              console.info('点击了'+this.imgUrl)
            })
        })
      }
      Image(this.imgUrl)
        .height(200)
        .width(200)
    }
    .height('100%')
    .width('100%')
  }
}
