require "time"
module Sort
  
  #计算电影得分
  def self.comput_score(date, ups, downs)
    #电影更新距离开站时间
    t = date - Time.new(1970, 1, 1)
    # 加分 与 减分 之差
    x = (ups.to_i - downs.to_i).abs
    #投票方向
    y = 1 if x > 0
    y = 0 if x == 0
    y =-1 if x < 0
    #电影受肯定的程度
    z = x if x != 0
    z = 1 if x == 0
    #得出分数
    Math.log10(z) + y*t/45000
  end
  
end
