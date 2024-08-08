local uiManager = activity.getUiManager()
local webView = uiManager.getCurrentFragment().getWebView()
local webloading = ProgressDialog.show(activity,nil,'请稍后...')
local indicator = activity.uiManager.getFragment(0).webView.parent.getChildAt(2)
indicator.color = 0

设置主标题("云数字人民币")

webView.setDownloadListener{
    onDownloadStart=function(url,a,b,c,d)
    import "android.content.Intent"
    import "android.net.Uri"
    
    viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
    activity.startActivity(viewIntent)

end}

local WebChromeClient = luajava.bindClass "android.webkit.WebChromeClient"
webView.setWebChromeClient(luajava.override(WebChromeClient,{
  onShowFileChooser = function(a, view, valueCallback, fileChooserParams)
    uploadFile = valueCallback
    import "android.content.Intent"
    local intent= Intent(Intent.ACTION_PICK)
    intent.setType("image/*")
    this.startActivityForResult(intent, 1)
    return true;
  end,
}))

onActivityResult=function(req,res,intent)
  local Activity = luajava.bindClass "android.app.Activity"
  local Uri = luajava.bindClass "android.net.Uri"
  if (res == Activity.RESULT_CANCELED) then
    if(uploadFile~=nil )then
      uploadFile.onReceiveValue(nil);
    end
  end
  local results
  if (res == Activity.RESULT_OK)then
    if(uploadFile==nil or type(uploadFile)=="number")then
      return;
    end
    if (intent ~= nil) then
      local dataString = intent.getDataString();
      local clipData = intent.getClipData();
      if (clipData ~= nil) then
        results = Uri[clipData.getItemCount()];
        for i = 0,clipData.getItemCount()-1 do
          local item = clipData.getItemAt(i);
          results[i] = item.getUri();
        end
      end
      if (dataString ~= nil) then
        results = Uri[1];
        results[0]=Uri.parse(dataString)
      end
    end
  end
  if(results~=nil)then
    uploadFile.onReceiveValue(results);
    uploadFile = nil;
  end
end

function Sleep(n)
   os.execute("sleep " .. n)
end

加载网页("https://www.ysszrmb.com/?isapp=true")

function onDrawerListItemClick(data, recyclerView, listIndex, itemIndex)
  local listData = data.get(listIndex);
  local itemData = listData.get(itemIndex);
  local itemTitle = itemData.getTitle();
  if itemTitle == "退出程序" then
    退出应用()
   else
   end
    抽屉开关()
end

顶栏菜单监听()
function 菜单事件.刷新()
  刷新网页()
end


function recreate()
  activity.finish();
  activity.startFusionActivity(activity.getLoader().getPageName());
  activity.overridePendingTransition(android_R.anim.fade_in,android_R.anim.fade_out);
end

local uimanager= activity.uiManager
local fragment = uimanager.currentFragment

fragment.setWebInterface(WebInterface{
  onPageFinished=function(view,url)
    webloading.dismiss()
  end,
  onPageStarted=function(view,url,favicon)
    webloading.show()
  end,
  onReceivedTitle=function(view,title)
    设置主标题(title)
  end,
  onLoadResource=function(view,url)
  end,
  onUrlLoad=function(view,url)
    return false
  end,
  onReceivedSslError=function(view, sslErrorHandler, sslError)
    webloading.show()
    return false
  end
})
