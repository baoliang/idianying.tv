
window.life = 
  logined: false
if $("#login_email").val() != ""
  window.life.logined = true
window.re_url = ""
window.MenuCtr = ($scope) ->

     
window.MoveCtr = ($scope, $http) ->
  $scope.add_hisotry = (id) ->
    if !window.life.logined 
      return
    $http
      "url": "/move/add_hisotry/#{id}?r=#{Math.random()}"
      "method": "GET"

  $scope.add_fav = (id) ->
    if !window.life.logined 
      $("#login").show()
      $("#login").modal()
      return
    txt = $("#fav_link").text()
    if $.trim(txt) == "已收藏"
      return
    $http
      "url": "/move/add_fav/#{id}?r=#{Math.random()}"
      "method": "GET"
    .success (data) ->
      $("#fav_link").text("已收藏")

   
  $scope.plus_score = (id) ->
    if !window.life.logined 
      $("#login").show()
      $("#login").modal()
      return 
    $http
      "url": "/move/plus_score/#{id}?r=#{Math.random()}"
      "method": "GET"
    .success (data) ->
      $("#score_#{id}").text(data.display_score)

  $scope.sub_score = (id) ->
    if !window.life.logined 
      $("#login").show()
      $("#login").modal()
      return     
    $http
      "url": "/move/sub_score/#{id}?r=#{Math.random()}"
      "method": "GET"
    .success (data) ->
      $("#score_#{id}").text(data.display_score)
      

window.UserCtr = ($scope, $http) ->

  user_login = (name) ->
    $("#user_name").text(name)
    $("#login,#user_login").hide()
    $("#login").modal("hide")
    $("#user_info").show()
    window.life.logined = true
    if window.location.pathname != "/"
      window.location.href=window.location.href

  $scope.login = () ->
    $http
      "url": "/user_login"
      "method": "GET"
      "params": 
        "email": $scope.email
        "pwd": $scope.pwd
    .success (data)->
      if data.name != undefined
        user_login data.name
      else:
        $("#login_tips").show()

  $scope.reg = () ->
    if $scope.r_email == undefined
      $scope.valid_email = "不能为空"
      return
    if $scope.r_name == undefined
      $scope.valid_name = "不能为空"
      return
    if $scope.r_pwd == undefined or $scope.r_pwd == ""
      $scope.valid_pwd = "不能为空"
      return
    $http
      "url": "/user_reg"
      "method": "GET"
      "params": 
        "email": $scope.r_email
        "name": $scope.r_name
        "pwd": $scope.r_pwd
    .success (data) ->
      if data.success != null
        if data.has
          if data.has == "email"
            $scope.valid_email = "邮箱已被占用"
          if data.has == "name"
            $scope.valid_name = "称呼已被占用"
          if data.has == "email_valid"
            $scope.valid_email = "邮箱格式错误"
          return

        user_login data.name

      
window.play = (url, index, id) ->
  $.get("/move/add_history/#{id}/#{index}")
  $("##{index}_c").css("color", "red")
  add_player(url, "true")

window.add_player = (url, auto) ->
  $("#player").qvod({PlayerArea:"player", width:"400", height:"300", AutoPlay:auto ,QvodUrl:url})
window.SocialShareButton =
  openUrl : (url) ->
    window.open(url)
    false

  share : (el) ->
    site = $(el).data('site')
    title = encodeURIComponent($(el).data('title'))
    img = encodeURIComponent($(el).data("img"))
    url = encodeURIComponent("http://idianying.tv/move/#{$(el).data("id")}")
    switch site
      when "weibo"
        SocialShareButton.openUrl("http://v.t.sina.com.cn/share/share.php?url=#{url}&pic=#{img}&title=#{title}&content=utf-8")
      when "twitter"
        SocialShareButton.openUrl("https://twitter.com/home?status=#{title}: #{url}")
      when "douban"
        SocialShareButton.openUrl("http://www.douban.com/recommend/?url=#{url}&title=#{title}&image=#{img}")
      when "facebook"
        SocialShareButton.openUrl("http://www.facebook.com/sharer.php?t=#{title}&u=#{url}")
      when "qq"
        SocialShareButton.openUrl("http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=#{url}&title=#{title}&pics=#{img}")
      when "tqq"
        SocialShareButton.openUrl("http://share.v.t.qq.com/index.php?c=share&a=index&url=#{url}&title=#{title}&pic=#{img}")
      when "baidu"
        SocialShareButton.openUrl("http://apps.hi.baidu.com/share/?url=#{url}&title=#{title}&content=")
      when "kaixin001"
        SocialShareButton.openUrl("http://www.kaixin001.com/rest/records.php?url=#{url}&content=#{title}&style=11&pic=#{img}")
      when "renren"
        SocialShareButton.openUrl("http://widget.renren.com/dialog/share?resourceUrl=#{url}&title=#{title}&description=")
      when "google_plus"
        SocialShareButton.openUrl("https://plus.google.com/share?url=#{url}&t=#{title}")
      when "google_bookmark"
        SocialShareButton.openUrl("https://www.google.com/bookmarks/mark?op=edit&output=popup&bkmk=#{url}&title=#{title}")
    false