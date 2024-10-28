/**
 * @Auhtor DLY
 *
 */
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { promptAction } from '@kit.ArkUI'
import { fileIo as fs, picker } from '@kit.CoreFileKit'
import { util } from '@kit.ArkTS'

@Entry
@Component
struct ViewPicker {
  @State imgUrl: string[] = []

  //[图库]:图片选择器
  async selectImage() {
    // 路径数组
    let photoUris: string[] = []
    //  创建图片选择器选项
    const options = new photoAccessHelper.PhotoSelectOptions()
    //设置选择图片类型
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
    //设置最大选择数量:5
    options.maxSelectNumber = 5
    // 调用PhotoViewPicker
    const result = new photoAccessHelper.PhotoViewPicker()
    result.select(options)// 点击完成之后,执行,传入结果
      .then((res: photoAccessHelper.PhotoSelectResult) => {
        photoUris = res.photoUris //选择的图片存入数组
        // 自定义处理
        if (photoUris.length > 0) {
          // [可选的]
          // 不推荐操作原始文件,推荐复制一个副本出来使用
          photoUris.forEach((uri: string) => {
            // 复制一个副本出来使用
            const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
            // 防止重名:生成唯一文件名
            const ext = uri.split('.').pop() //获取文件后缀名||uri.substring(uri.lastIndexOf('.'))
            const fileName = util.generateRandomUUID(true) + '.' + ext
            const fileUri = getContext(this).filesDir + '/' + fileName
            console.log('复制副本文件:', fileName)
            // 复制文件到指定目录
            fs.copyFileSync(file.fd, fileUri)

            // 保存到数组中
            this.imgUrl.push('file://' + fileUri)

            // 关闭文件
            fs.closeSync(file.fd)
          })
        }
      }).catch((e: Error) => {
      promptAction.showToast({
        message: "选择图片失败:" + JSON.stringify(e),
      })
    })


  }

  //[文件选择器]:文件选择器
  async selectFile() {
    let fileUri: string[] = []
    // 创建文件选择器选项
    const documentViewPicker = new picker.DocumentViewPicker()
    // 文档选择器选项
    const options = new picker.DocumentSelectOptions
    // 设置:一次性选择多个文件
    options.maxSelectNumber = 5

    // 调用DocumentViewPicker
    documentViewPicker.select(options)// 点击完成之后,执行,传入结果
      .then((res: string[]) => {
        fileUri = res //选择的文件存入数组
        if (fileUri.length > 0) {
          fileUri.forEach((uri: string) => {
            const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
            const fileName = util.generateRandomUUID()
            // 定义读取大小
            let bufferSize = new ArrayBuffer(file.fd)

            // 读取文件大小
            let readSize = 0
            // 读取文件内容
            let result = ''
            //读取文件:一个一个字符读取(源文件,保存的大小,)
            let readLength = fs.readSync(file.fd, bufferSize, { offset: readSize })
            // 循环读取文件内容,直到0
            while (readLength > 0) {
              // 记录读取多少
              readSize += readLength
              // 创建文件编码对象
              const textDecoder = util.TextDecoder.create('utf-8')
              // 累加读取内容
              result += textDecoder.decodeToString(new Uint8Array(bufferSize))
              // 读取下一段内容
              readLength = fs.readSync(file.fd, bufferSize, { offset: readSize })

            }
            // 自定义处理内容:读取文件内容
            //通常都是txt类型的
            //

            console.info('读取文件内容:', result)

          })
        }
      }).catch((e: Error) => {
    })

  }

  //[媒体]:媒体选择器
  async selectMedia() {
    // 路径数组
    let mediaUris: string[] = []
    //  创建图片选择器选项
    const options = new picker.AudioSelectOptions
    //设置最大选择数量:5
    options.maxSelectNumber = 5
    // 调用PhotoViewPicker
    const audioViewPicker = new picker.AudioViewPicker()
    audioViewPicker.select(options)// 点击完成之后,执行,传入结果
      .then((res: string[]) => {
        if (res.length) {
          mediaUris = res //选择的图片存入数组
          // 自定义处理
          // [可选的]
          // 不推荐操作原始文件,推荐复制一个副本出来使用
          mediaUris.forEach((uri: string) => {
            // 复制一个副本出来使用
            const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
            // 防止重名:生成唯一文件名
            const ext = uri.split('.').pop() //获取文件后缀名||uri.substring(uri.lastIndexOf('.'))
            const fileName = util.generateRandomUUID(true) + '.' + ext
            const fileUri = getContext(this).filesDir + '/' + fileName
            console.log('复制副本文件:', fileName)
            // 复制文件到指定目录
            fs.copyFileSync(file.fd, fileUri)
            // 关闭文件
            fs.closeSync(file.fd)
          })
        }
      }).catch((e: Error) => {
      promptAction.showToast({
        message: "选择图片失败:" + JSON.stringify(e),
      })
    })


  }

  build() {
    Column({ space: 20 }) {
      //[图库]:图片选择器
      Button('选择展示图片-[图库]')
        .onClick(() => {
          this.selectImage()
        })


      List() {
        ForEach(this.imgUrl, (item: string, index) => {
          ListItem() {
            Image(item).width('100%').height('100%')
          }
        })
      }
      .width('100%')


      Divider()

      //[文件选择器]:文件选择器
      Button('选择文件-[文件选择器]')
        .onClick(() => {
          this.selectFile()
        })


      Divider()
      //[音乐]:音乐媒体选择器
      Button('选择影音-[媒体]')
        .onClick(() => {
          this.selectMedia()
        })


    }
    .width('100%')
    .height('100%')
    .backgroundImage(this.imgUrl[0])
    .backgroundImageSize(ImageSize.Cover)

  }
}