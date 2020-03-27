#####################################################################
# 
# # 데이터 수집(Web Scraping, Web Crawling)
# 
# # 웹사이트 상에서 내가 원하는 위치에 대한 정보를
# # 자동으로 추출하여 수집하는 기능 -> Web Scraping
# 
# # 자동화 봇인 Web Crawler가 정해진 규칙에 따라
# # 복수개의 웹페이지를 browsing하는 행위
# 
#####################################################################
# 
# # Web Scraping
# 
# > CSS, jQuery(selector)
# > XPATH
# 
# 
# # selector를 이용한 Web Scraping
# 
# * CSS로 selector 알아보기.
#   - Eclipse는 Back-End 프로그램에 최적화. Front-End는 살짝...
#   - Webstorm 사용
# 
# 
# # 네이버 영화 댓글 페이지에서 scraping 하기.
# 
install.packages("rvest")
library(rvest)
library(stringr)

# 
# # 스크랩핑 해봅시다!
# 
url <- "https://movie.naver.com/movie/point/af/list.nhn?&page="
request_url <- str_c(url,"1")
request_url

#
page_html <- read_html(request_url, encoding = "CP949")
page_html                         # target 페이지의 현재 인코딩에 맞춰주어야한다.

# 
# td.title > a.movie
# div.list_netizen_score > em
# td.title  >> remove \t  >> split \n  >> get line 11/21
#                                              line 4 : title
#                                              line 9 : "별점 - 총 10점 중9" 
# 

# html 중 selecter에 맞는 element를 가져온다.
nodes <- html_nodes(page_html, "td.title > a.movie")

# element가 가지고 있는 text(tag 사이의 내용)를 가져온다.
movie_title <- html_text(nodes)

movie_title     # 1페이지 영화 제목들(10개)

# 
nodes <- html_nodes(page_html, "div.list_netizen_score > em")
movie_point <- html_text(nodes)
movie_point     # 1페이지 영화 평점들

# 
nodes <- html_nodes(page_html, "td.title")
content <- html_text(nodes)

for (i in 1:length(content)) {
  temp <- str_remove_all(content[i], "\t")
  temp <- str_split(temp, "\n")
  content[i] <- temp[[1]][11]
}
content         # 1페이지 리뷰들

#
#####################################################################
# 
# # 4일차(20200312)
# 
# # 지금까지 배운것
# > R의 데이터 타입, 자료구조
# > R의 데이터 수집
#   - 파일로부터 데이터를 읽어들이는 방법
#   - Web Application을 통한 데이터 획득(JSON)
#   - Web Scraping을 통해서 Web Page의 데이터 획득
#     (selector를 이용해 처리)
# 
# # 오늘
#   - XPATH를 이용한 처리
# 
# > 수행평가 문제가 제출됩니다.
#   - 2019년도 영화 Top 100?
# 
# 
# > 데이터 조작
#   - data frame을 조작하는 방법
#   - 예제
#   - 문제
# 
# 
#####################################################################
# 
# # XPATH
# 
install.packages("rvest")     # scraping 을 위한 package
library(rvest)
library(stringr)

# 
url <- "https://movie.naver.com/movie/point/af/list.nhn?&page="
request_url <- str_c(url,1)       # crawling browsing을 위해 page를 따로 분리
request_url

# url을 이용해 해당 페이지의 내용 가져오기.
page_html <- read_html(request_url, encoding = "CP949")
page_html

# 
# 영화제목
#   - selector 방식
#   - html_node()   : tag 기반 검색
nodes <- html_nodes(page_html, "td.title > a.movie")
titles <- html_text(nodes)
titles

#
#   - XPATH 방식.
#
#     (Chrome에서 제공하는 xpath 사용)
#     //*[@id="old_content"]/table/tbody/tr[1]/td[2]/a[1]
#     //*[@id="old_content"]/table/tbody/tr[2]/td[2]/a[1]
#                                           ^
movie_title = vector(mode = "character", length = 10)
for (i in 1:10) {
  myPath <- str_c('//*[@id="old_content"]/table/tbody/tr[',i,']/td[2]/a[1]/text()')
  nodes <- html_nodes(page_html, xpath = myPath)
  movie_title[i] <- html_text(nodes)
}
movie_title

# 
# 평점
# 
nodes <- html_nodes(page_html, "div.list_netizen_score > em")
points <- html_text(nodes)
points

# 
# 리뷰
#   - selector
#
nodes <- html_nodes(page_html, "td.title")
content <- html_text(nodes)

for (i in 1:length(content)) {
  temp <- str_remove_all(content[i], "\t")
  temp <- str_split(temp, "\n")
  content[i] <- temp[[1]][11]
}
content

#   - xpath
#     //*[@id="old_content"]/table/tbody/tr[1]/td[2]/text()
#     //*[@id="old_content"]/table/tbody/tr[2]/td[2]/text()
movie_content = vector(mode = "character", length = 10)
for (i in 1:10) {
  myPath <- str_c('//*[@id="old_content"]/table/tbody/tr[',i,']/td[2]/text()')
  nodes <- html_nodes(page_html, xpath = myPath)
  movie_content[i] <- html_text(nodes)
}
movie_content



#####################################################################
# 
# 로튼토마토 사이트에서 2019년 인기 영화 100개의
# 제목, user rating, genre 추출해서 파일로 저장.
# 
rate_url <- "https://www.rottentomatoes.com/top/bestofrt/?year=2019"
base_url <- "https://www.rottentomatoes.com"

page_html <- read_html(rate_url)

# ------------------------------------------------------------------#
#            결과 코드
# ------------------------------------------------------------------#

nodes <- html_nodes(page_html, "table.table > tr > td > a")
nodes

# 상대경로들
mUrl <- html_attr(nodes, 'href')
mUrl

# 제목, user rating, genre
movie_title <- vector(mode = "character", length = 100)
movie_rating <- vector(mode = "character", length = 100)
movie_genre <- vector(mode = "character", length = 100)

for (i in 1:100) {
  # i <- 1
  target_url <- str_c(base_url, mUrl[i])
  target_html <- read_html(target_url)
  
  # title
  title_node <- html_node(target_html, 
                          xpath = '//*[@id="topSection"]/div[2]/div[1]/h1')
  movie_title[i] <- html_text(title_node)
  
  # rating
  rating_node <- html_node(target_html, 
                           xpath = '//*[@id="topSection"]/div[2]/div[1]/section/section/div[2]/h2/a/span[2]')
  text <- html_text(rating_node)
  text <- str_remove_all(text, "\n")
  text <- str_remove_all(text, " ")
  movie_rating[i] <- text
  
  # genre
  genre_node <- html_nodes(target_html, 
                           xpath = '//div[@class="media-body"]/div/ul/li[2]/div[2]/a')
  text <- html_text(genre_node)
  # for (j in 1:length(text)-1) {
  #   genre <- str_c(text[1], ", ", text[j+1])
  # }
  movie_genre[i] <- paste(text, collapse = ", ")
}
movie_title
movie_rating
movie_genre

df <- data.frame(Title  = movie_title,
                 Rating = movie_rating,
                 Genre  = movie_genre)
df
View(df)

write.table(df,
            file = "data/rottentomatoes_top_2019.csv",
            sep = "/",
            row.names = FALSE,
            quote = FALSE)

# ------------------------------------------------------------------#
#            연습 코드
# ------------------------------------------------------------------#
'//*[@id="top_movies_main"]/div/table/tr[1]/td[3]/a'
'//*[@id="top_movies_main"]/div/table/tr[2]/td[3]/a'
'//*[@id="top_movies_main"]/div/table/tr[100]/td[3]/a'

myPath <- '//*[@id="top_movies_main"]/div/table/tr[1]/td[3]'
nodes <- html_node(page_html, xpath = myPath)

##
movie_title = vector(mode = "character", length = 100)
for (i in 1:100) {
  myPath <- str_c('//*[@id="top_movies_main"]/div/table/tr[',i,']/td[3]')
  nodes <- html_nodes(page_html, xpath = myPath)
  movie_title[i] <- html_text(nodes)
}
movie_title


##
nodes <- html_nodes(page_html, "table.table")
nodes
length(nodes)

nodes <- html_nodes(page_html, "table.table > tr > td > a")
nodes

# 상대경로들
mUrl <- html_attr(nodes, 'href')
mUrl
 
# title들     # [1] "\n            Parasite (Gisaengchung) (2019)" ...
titles <- html_text(nodes)
titles

#
# 제목, user rating, genre
movie_title <- vector(mode = "character", length = 100)
movie_rating <- vector(mode = "character", length = 100)
movie_genre <- vector(mode = "character", length = 100)

for (i in 1:100) {
  target_url <- str_c(base_url, mUrl[i])
  target_html <- read_html(target_url)
  # title
  title_node <- html_node(target_html, xpath = '//*[@id="topSection"]/div[2]/div[1]/h1')
  movie_title[i] <- html_text(title_node)
  # rating
  rating_node <- html_node(target_html, xpath = '//*[@id="topSection"]/div[2]/div[1]/section/section/div[2]/h2/a/span[2]')
  text <- html_text(rating_node)
  text <- str_remove_all(text, "\n")
  text <- str_remove_all(text, " ")
  movie_rating[i] <- text
  # genre
  genre_node <- html_nodes(target_html, xpath = '//div[@class="media-body"]/div/ul/li[2]/div[2]/a')
  text <- html_text(genre_node)
  genre <- ""
  for (i in 1:length(text)-1) {
    genre <- str_c(text[1], ", ", text[i+1])
  }
  movie_genre <- genre
}
movie_title
movie_rating
movie_genre

##### test

target_url <- str_c(base_url, mUrl[1])
target_html <- read_html(target_url)
target_html

'//*[@id="topSection"]/div[2]/div[1]/h1'
title_node <- html_node(target_html, xpath = '//*[@id="topSection"]/div[2]/div[1]/h1')
html_text(title_node)

'//*[@id="topSection"]/div[2]/div[1]/section/section/div[2]/h2/a/span[2]'
rating_node <- html_node(target_html, xpath = '//*[@id="topSection"]/div[2]/div[1]/section/section/div[2]/h2/a/span[2]')
text <- html_text(rating_node)
text <- str_remove_all(text, "\n")
text <- str_remove_all(text, " ")

'//*[@id="mainColumn"]/section[4]/div/div/ul/li[2]/div[2]'
genre_node <- html_node(target_html, xpath = '//*[@id="mainColumn"]/section[4]/div/div/ul/li[2]/div[2]')

genre_node <- html_nodes(target_html, "ul.info")
genre_node <- html_nodes(target_html, "ul.info > li")
genre_node <- html_nodes(target_html, "ul.info > li > div.meta-value")
genre_node


'//*[@id="mainColumn"]/section[4]/div/div/ul/li[2]/div[2]'
'//*[@id="mainColumn"]/section[4]/div/div/ul/li[2]/div[2]/a[1]'

'//*[@class=media-body]'

genre_node <- html_nodes(target_html, xpath = '//div[@class="media-body"]/div/ul/li[2]/div[2]')
text <- html_text(genre_node)
text <- str_remove_all(text, "\n")
text <- str_remove_all(text, " ")
text <- str_replace(text, ",", ", ")


genre_node <- html_nodes(target_html, xpath = '//div[@class="media-body"]/div/ul/li[2]/div[2]/a')
text <- html_text(genre_node)
genre <- ""
for (i in 1:length(text)-1) {
   genre <- str_c(text[1], ", ", text[i+1])
}
genre

View(genre_node)

# nodes <- html_nodes(page_html, "td.title > a.movie")
# titles <- html_text(nodes)
# titles

#####################################################################
# 
# # 데이터 조작 #
# 
# > SQL처럼 빅데이터 내에서 필요한 정보를 추출하는 방법
# 
# 
# 
install.packages("ggplot2")
library(ggplot2)

mpg     # table 형식
        # Fuel Economy Data From 1999 To 2008 For 38 Popular Models Of Cars

df <- as.data.frame(mpg)
View(mpg)

# ---------------------------------------------------------
#
# # 기본적인 함수
# 
# > 1. class()  : 자료구조를 알고싶을때 - 자료구조가 문자열로 출력
# 
class(df)     # [1] "data.frame"

# 
# > 2. ls()     : data frame에 적용하면 컬럼을 출력(retrun vector)
# 
ls(df)
# [1] "class"        "cty"          "cyl"          "displ"        "drv"          "fl"          
# [7] "hwy"          "manufacturer" "model"        "trans"        "year" 

# 
# > 3. head()   : 데이터의 앞쪽 6개만 출력
# 
head(df)
#   manufacturer model displ year cyl      trans drv cty hwy fl   class
# 1         audi    a4   1.8 1999   4   auto(l5)   f  18  29  p compact
# 2         audi    a4   1.8 1999   4 manual(m5)   f  21  29  p compact
# 3         audi    a4   2.0 2008   4 manual(m6)   f  20  31  p compact
# 4         audi    a4   2.0 2008   4   auto(av)   f  21  30  p compact
# 5         audi    a4   2.8 1999   6   auto(l5)   f  16  26  p compact
# 6         audi    a4   2.8 1999   6 manual(m5)   f  18  26  p compact

# 
# > 4. tail()   : 데이터의 뒤쪽 6개 출력
# 
tail(df)
#     manufacturer  model displ year cyl      trans drv cty hwy fl   class
# 229   volkswagen passat   1.8 1999   4   auto(l5)   f  18  29  p midsize
# 230   volkswagen passat   2.0 2008   4   auto(s6)   f  19  28  p midsize
# 231   volkswagen passat   2.0 2008   4 manual(m6)   f  21  29  p midsize
# 232   volkswagen passat   2.8 1999   6   auto(l5)   f  16  26  p midsize
# 233   volkswagen passat   2.8 1999   6 manual(m5)   f  18  26  p midsize
# 234   volkswagen passat   3.6 2008   6   auto(s6)   f  17  26  p midsize

# 
# > 5. View()   : View 창을 이용해서 데이터 출력
# 
View(df)

# 
# > 6. dim()    : 행과 열의 갯수를 출력
# 
dim(df)     # [1] 234  11

# 
# > 7. nrow()   : 행의 갯수
# 
nrow(df)    # [1] 234

# 
# > 8. ncol()   : 열의 갯수
# 
ncol(df)    # [1] 11

# 
# > 9. str()    : data frame의 전반적인 정보를 출력
# 
str(df)
# 'data.frame':	234 obs. of  11 variables:
# $ manufacturer: chr  "audi" "audi" "audi" "audi" ...
# $ model       : chr  "a4" "a4" "a4" "a4" ...
# $ displ       : num  1.8 1.8 2 2 2.8 2.8 3.1 1.8 1.8 2 ...
# $ year        : int  1999 1999 2008 2008 1999 1999 2008 1999 1999 2008 ...
# $ cyl         : int  4 4 4 4 6 6 6 4 4 4 ...
# $ trans       : chr  "auto(l5)" "manual(m5)" "manual(m6)" "auto(av)" ...
# $ drv         : chr  "f" "f" "f" "f" ...
# $ cty         : int  18 21 20 21 16 18 18 18 16 20 ...
# $ hwy         : int  29 29 31 30 26 26 27 26 25 28 ...
# $ fl          : chr  "p" "p" "p" "p" ...
# $ class       : chr  "compact" "compact" "compact" "compact" ...

# 
# > 10. length()  : 갯수를 구하는 함수
#               ! data frame에 적용시키면 column의 갯수 반환
# 
length(df)    # [1] 11

# 
# > 11. summary() : 간단한 통계치를 보여준다.(숫자에 대해서)
# 
summary(df)
# manufacturer          model               displ            year           cyl       
# Length:234         Length:234         Min.   :1.600   Min.   :1999   Min.   :4.000  
# Class :character   Class :character   1st Qu.:2.400   1st Qu.:1999   1st Qu.:4.000  
# Mode  :character   Mode  :character   Median :3.300   Median :2004   Median :6.000  
#                                       Mean   :3.472   Mean   :2004   Mean   :5.889  
#                                       3rd Qu.:4.600   3rd Qu.:2008   3rd Qu.:8.000  
#                                       Max.   :7.000   Max.   :2008   Max.   :8.000  
# trans               drv                 cty             hwy             fl           
# Length:234         Length:234         Min.   : 9.00   Min.   :12.00   Length:234        
# Class :character   Class :character   1st Qu.:14.00   1st Qu.:18.00   Class :character  
# Mode  :character   Mode  :character   Median :17.00   Median :24.00   Mode  :character  
#                                       Mean   :16.86   Mean   :23.44                   
#                                       3rd Qu.:19.00   3rd Qu.:27.00                     
#                                       Max.   :35.00   Max.   :44.00                     
# class          
# Length:234        
# Class :character  
# Mode  :character  

# 
# # 여기까지는 기본함수
# 
# ---------------------------------------------------------
# 
# > data frame을 제어해서 원하는 정보를 추출하려면
#   특수한 package를 사용하는게 좋다.
#   
# > 가장 많이 사용되는 data frame 제어 package : dplyr
#                                               d ply r
#
install.packages("dplyr")
library(dplyr)

# 
# # dplyr을 이용해서 data frame 제어하기
# 
# > data frame 하나 가져오자
# 
library(xlsx)

# excel_data <- read.xlsx(file.choose(), sheetIndex = 1, encoding = "UTF-8")
excel_data <- read.xlsx("data/2016_2017_이용건수_및_이용금액.xlsx", 
                        sheetIndex = 1, encoding = "UTF-8")
View(excel_data)

# 
# > dplyr은 data frame을 제어하는데 특화된 함수를 제공한다.
# > chaining을 지원하기 때문에 편하게 data frame을 제어할 수 있다.
#   ( %>% )
# 

# 
# # 함수들
# 
# > 1. rename(data frame, newVar = var)
#     컬럼명을 변경할 수 있다.
# 
names(excel_data)   
# [1] "ID"      "SEX"     "AGE"     "AREA"    "AMT17"   "Y17_CNT" "AMT16"   "Y16_CNT"

df <- rename(excel_data, Y17_AMT = AMT17)
names(df)
# [1] "ID"      "SEX"     "AGE"     "AREA"    "Y17_AMT" "Y17_CNT" "AMT16"   "Y16_CNT"

df <- rename(excel_data, 
             Y17_AMT = AMT17,
             Y16_AMT = AMT16)
      # 복수개 변경 가능
      # 변경대상 = 기본 이름름

# 
# > 2. filter(data frame, 조건1, 조건2, ...)
# 
df <- filter(excel_data, SEX=="M", AREA=="서울")
df
#   ID SEX AGE AREA  AMT17 Y17_CNT  AMT16 Y16_CNT
# 1  2   M  40 경기 450000      25 700000      30   < 조건1
# 2  4   M  50 서울 400000       8 125000       3   < 조건1, 조건2
# 3  5   M  27 서울 845000      30 760000      28   < 조건1, 조건2
# 4  9   M  20 인천 930000       4 250000       2   < 조건1

df <- filter(excel_data, SEX=="M", AREA %in% c("서울", "경기"))
df
#   ID SEX AGE AREA  AMT17 Y17_CNT  AMT16 Y16_CNT
# 1  2   M  40 경기 450000      25 700000      30
# 2  4   M  50 서울 400000       8 125000       3
# 3  5   M  27 서울 845000      30 760000      28

# 
# > 3. arrange(data frame, column이름1, desc(column이름2), ...)
#     기본적으로 정렬은 오름차순 정렬
#     내림차순 정령시에는 desc() 사용
# 
df <- arrange(excel_data, SEX)
df
#    ID SEX AGE AREA   AMT17 Y17_CNT  AMT16 Y16_CNT
# 1   1   F  50 서울 1300000      50 100000      40
# 2   3   F  28 제주  275000      10  50000       5
# 3   6   F  23 서울   42900       1 300000       6
# 4   7   F  56 경기  150000       2 130000       2
# 5   8   F  47 서울  570000      10 400000       7
# 6  10   F  38 경기  520000      17 550000      16
# 7   2   M  40 경기  450000      25 700000      30
# 8   4   M  50 서울  400000       8 125000       3
# 9   5   M  27 서울  845000      30 760000      28
# 10  9   M  20 인천  930000       4 250000       2

df <- arrange(excel_data, SEX, desc(AGE))
df
#    ID SEX AGE AREA   AMT17 Y17_CNT  AMT16 Y16_CNT
# 1   7   F  56 경기  150000       2 130000       2
# 2   1   F  50 서울 1300000      50 100000      40
# 3   8   F  47 서울  570000      10 400000       7
# 4  10   F  38 경기  520000      17 550000      16
# 5   3   F  28 제주  275000      10  50000       5
# 6   6   F  23 서울   42900       1 300000       6
# 7   4   M  50 서울  400000       8 125000       3
# 8   2   M  40 경기  450000      25 700000      30
# 9   5   M  27 서울  845000      30 760000      28
# 10  9   M  20 인천  930000       4 250000       2


# 
# !! 성별이 남성인 사람들만 찾아서 나이순으로 내림차순하여 정렬하기.
# 
df <- filter(excel_data, SEX=="M") %>% arrange(desc(AGE))
df
#     함수1                            함수2
#     함수1의 결과를 함수2의 결과에 넘겨 연산

# 
# > 4. select(data frame, 컬럼명1, 컬럼명2, .....)
# 
df <- filter(excel_data, SEX=="M") %>% 
      arrange(desc(AGE)) %>% 
      select(ID, SEX, AREA)
df
#   ID SEX AREA
# 1  4   M 서울
# 2  2   M 경기
# 3  5   M 서울
# 4  9   M 인천

df <- filter(excel_data, SEX=="M") %>% 
      arrange(desc(AGE)) %>% 
      select(-SEX)            # -컬럼 : 해당 컬럼 제외
df
#   ID AGE AREA  AMT17 Y17_CNT  AMT16 Y16_CNT
# 1  4  50 서울 400000       8 125000       3
# 2  2  40 경기 450000      25 700000      30
# 3  5  27 서울 845000      30 760000      28
# 4  9  20 인천 930000       4 250000       2

# 
# > 5. mutate(data frame, column명=수식, column명=수식, .....)
# 
#     - 원본 data frame에서 남자중에서 AMT17의 값이 100,000 이상인 사람을 찾아 VIP 설정
# 
df <- filter(excel_data, SEX=="M") %>%
      mutate(VIP=AMT17>500000)
df
#   ID SEX AGE AREA  AMT17 Y17_CNT  AMT16 Y16_CNT   VIP
# 1  2   M  40 경기 450000      25 700000      30 FALSE
# 2  4   M  50 서울 400000       8 125000       3 FALSE
# 3  5   M  27 서울 845000      30 760000      28  TRUE
# 4  9   M  20 인천 930000       4 250000       2  TRUE


# 
# > 6. summarise(data frame, 추가할 column명=함수, column명=함수,.....)
# 
df <- summarise(excel_data,
                SUM17AMT=sum(AMT17), cnt=n())
df
#   SUM17AMT cnt
# 1  5482900  10


# 
# > 7. group_by(data frame, 범주형 column)
# 
df <- group_by(excel_data,SEX) %>%
      summarise(SUM17AMT=sum(AMT17), cnt=n())
df
# # A tibble: 2 x 3
# SEX     SUM17AMT   cnt
# <fct>      <dbl> <int>
# 1 F      2857900     6
# 2 M      2625000     4

# 
# > 8. bind_rows(df1, df2)
#     - 2개의 df를 붙인다!
#     - 대신, column 명이 같아야한다.
# 
df1 <- data.frame(x=c(1,2,3))
df1
#   x
# 1 1
# 2 2
# 3 3

df2 <- data.frame(y=c(4,5,6))
df2
#   y
# 1 4
# 2 5
# 3 6

bind_rows(df1, df2)
#    x  y
# 1  1 NA
# 2  2 NA
# 3  3 NA
# 4 NA  4
# 5 NA  5
# 6 NA  6

# 
#####################################################################
# 
# # 연습문제
# 
# > data set은 mpg(자동차 연비데이터)를 이용
# 
# > EDA(탐색적 데티어 분석)
# > 제공된 문제 파일을 해결해보기
# 

# -----------------------------------------------------#
#
# # 제공된 파일
#
# -----------------------------------------------------#
# ggplot2 package의 mpg data 활용

install.packages("ggplot2")
library(ggplot2)

mpg = as.data.frame(mpg)   # mpg data frame

View(mpg)

# 주요컬럼
# manufacturer : 제조회사
# displ : 배기량
# cyl : 실린더 개수
# drv : 구동 방식
# hwy : 고속도로 연비
# class : 자동차 종류
# model : 자동차 모델명
# year : 생산연도
# trans : 변속기 종류
# cty : 도시 연비
# fl : 연료 종류

# 1. 자동차 배기량에 따라 고속도로 연비가 다른지 알아보려 한다. 
# displ(배기량)이 4 이하인 자동차와 4 초과인 자동차 중 
# 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 더 높은지 확인하세요.

df <- mutate(mpg,
             DISPL_DIFF = ifelse(displ <= 4, "4 LOW", "4 HIGH")) %>%
      group_by(DISPL_DIFF) %>%
      summarise(AVG_HWY = mean(hwy))
df
# # A tibble: 2 x 2
# DISPL_DIFF AVG_HWY
# <chr>        <dbl>
# 1 4 HIGH      17.6
# 2 4 LOW       26.0    < 배기량 4 이하의 차량의 hwy가 더 높다.


# 2. 자동차 제조 회사에 따라 도시 연비가 다른지 알아보려고 한다. 
# "audi"와 "toyota" 중 어느 manufacturer(제조회사)의 cty(도시 연비)가 
# 평균적으로 더 높은지 확인하세요.
df <- filter(mpg, manufacturer %in% c("audi", "toyota")) %>%
      group_by(manufacturer) %>%
      summarise(AVG_CTY = mean(cty))
df
# # A tibble: 2 x 2
# manufacturer AVG_CTY
# <chr>          <dbl>
# 1 audi          17.6
# 2 toyota        18.5  < toyota 의 cty 연비 평균이 더 높다.


# 3. "chevrolet", "ford", "honda" 자동차의 고속도로 연비 평균을 알아보려고 한다. 
# 이 회사들의 데이터를 추출한 후 hwy(고속도로 연비) 전체 평균을 구하세요.
df <- filter(mpg, manufacturer %in% c("chevrolet", "ford", "honda")) %>%
    summarise(AVG_HWY = mean(hwy))
df
#     AVG_HWY
# 1  22.50943


# 4. "audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 
# 높은지 알아보려고 한다. "audi"에서 생산한 자동차 중 hwy가 1~5위에 해당하는 
# 자동차의 데이터를 출력하세요.
df <- filter(mpg, manufacturer=="audi") %>%
    arrange(desc(hwy)) %>% head(5)
df
#   manufacturer      model displ year cyl      trans drv cty hwy fl   class
# 1         audi         a4   2.0 2008   4 manual(m6)   f  20  31  p compact
# 2         audi         a4   2.0 2008   4   auto(av)   f  21  30  p compact
# 3         audi         a4   1.8 1999   4   auto(l5)   f  18  29  p compact
# 4         audi         a4   1.8 1999   4 manual(m5)   f  21  29  p compact
# 5         audi a4 quattro   2.0 2008   4 manual(m6)   4  20  28  p compact
# 6         audi         a4   3.1 2008   6   auto(av)   f  18  27  p compact


# 5. mpg 데이터는 연비를 나타내는 변수가 2개입니다. 
# 두 변수를 각각 활용하는 대신 하나의 통합 연비 변수를 만들어 사용하려 합니다. 
# 평균 연비 변수는 두 연비(고속도로와 도시)의 평균을 이용합니다. 
# 회사별로 "suv" 자동차의 평균 연비를 구한후 내림차순으로 정렬한 후 1~5위까지 데이터를 출력하세요.
df <- filter(mpg, class=="suv") %>%
      mutate(MPG=((cty + hwy)/2)) %>%
      arrange(desc(MPG)) %>% head()
df
#                                                                              v
#   manufacturer        model displ year cyl      trans drv cty hwy fl class  MPG
# 1       subaru forester awd   2.5 2008   4 manual(m5)   4  20  27  r   suv 23.5
# 2       subaru forester awd   2.5 2008   4   auto(l4)   4  20  26  r   suv 23.0
# 3       subaru forester awd   2.5 2008   4 manual(m5)   4  19  25  p   suv 22.0
# 4       subaru forester awd   2.5 1999   4 manual(m5)   4  18  25  r   suv 21.5
# 5       subaru forester awd   2.5 1999   4   auto(l4)   4  18  24  r   suv 21.0
# 6       subaru forester awd   2.5 2008   4   auto(l4)   4  18  23  p   suv 20.5


# + 회사별 ***
df <- filter(mpg, class=="suv") %>%
      mutate(MPG=((cty+hwy)/2)) %>%
      group_by(manufacturer) %>% 
      summarise(AVG_MPG = mean(MPG)) %>%
      arrange(desc(AVG_MPG)) %>% head(5)
df
# A tibble: 5 x 2
# manufacturer   AVG_MPG
# <chr>            <dbl>
# 1 subaru          21.9
# 2 toyota          16.3
# 3 nissan          15.9
# 4 mercury         15.6
# 5 jeep            15.6


# 6. mpg 데이터의 class는 "suv", "compact" 등 자동차의 특징에 따라 
# 일곱 종류로 분류한 변수입니다. 어떤 차종의 도시 연비가 높은지 비교하려 합니다. 
# class별 cty 평균을 구하고 cty 평균이 높은 순으로 정렬해 출력하세요.
df <- group_by(mpg, class) %>% 
      summarise(AVG_CTY = mean(cty)) %>%
      arrange(desc(AVG_CTY))
df
# # A tibble: 7 x 2
# class        AVG_CTY
# <chr>          <dbl>
# 1 subcompact    20.4
# 2 compact       20.1
# 3 midsize       18.8
# 4 minivan       15.8
# 5 2seater       15.4
# 6 suv           13.5
# 7 pickup        13 


# 7. 어떤 회사 자동차의 hwy(고속도로 연비)가 가장 높은지 알아보려 합니다. 
# hwy(고속도로 연비) 평균이 가장 높은 회사 세 곳을 출력하세요.
df <- group_by(mpg, manufacturer) %>%
      summarise(AVG_HWY = mean(hwy)) %>%
      arrange(desc(AVG_HWY)) %>% head(3)
df
# # A tibble: 3 x 2
# manufacturer   AVG_HWY
# <chr>            <dbl>
# 1 honda           32.6
# 2 volkswagen      29.2
# 3 hyundai         26.9


# 8. 어떤 회사에서 "compact" 차종을 가장 많이 생산하는지 알아보려고 합니다. 
# 각 회사별 "compact" 차종 수를 내림차순으로 정렬해 출력하세요.
df <- filter(mpg, class=="compact") %>%
      group_by(manufacturer) %>%
      summarise(compact = n()) %>%
      arrange(desc(compact))
df
# # A tibble: 5 x 2
# manufacturer   compact
# <chr>            <int>
# 1 audi              15
# 2 volkswagen        14
# 3 toyota            12
# 4 subaru             4
# 5 nissan             2  


########################################################
# 
# # 데이터 정제(전처리)
#
# > 데이터 분석 이전에 raw데이터(현장에서 수집된 가공되지 않은 데이터)를
#   분석이 가능한 형태로 가공하는 작업이 선행되어야 한다.
# 
# # 1. 결측치를 해결해야 한다.
#   
#   > NA를 처리하기 위해서 사용하는 함수
#   
#   # 1-1. is.na()
#   

df <- data.frame(id=c(1,2,NA,4,NA,6),
                 score=c(20,30,NA,50,70,NA))
df
#   id score
# 1  1    20
# 2  2    30
# 3 NA    NA
# 4  4    50
# 5 NA    70
# 6  6    NA


is.na(df)
#         id score
# [1,] FALSE FALSE
# [2,] FALSE FALSE
# [3,]  TRUE  TRUE
# [4,] FALSE FALSE
# [5,]  TRUE FALSE
# [6,] FALSE  TRUE

is.na(df$id)
# [1] FALSE FALSE  TRUE FALSE  TRUE FALSE

# 
#   > NA가 들어가 있는 데이터가 전체 데이터 크기에 비해
#     상대적으로 아주 적을때에는 삭제하는게 좋을 수 있다.
# 

library(dplyr)

#
#   # 1-2. filter() & is.na()
#
# id가 NA인 row를 data frame에서 삭제
result <- df %>% filter(!is.na(df$id))
result
#   id score
# 1  1    20
# 2  2    30
# 3  4    50
# 4  6    NA

# df에서 NA가 포함된 모든 row를 삭제
result <- df %>% filter(!is.na(df$id), !is.na(df$score))
result
#   id score
# 1  1    20
# 2  2    30
# 3  4    50


# 
#   # 1-3. na.omit()
#     > 모든 NA를 찾아서 NA가 포함된 row를 삭제하는 함수
# 
result <- na.omit(df)
result
#   id score
# 1  1    20
# 2  2    30
# 4  4    50

# 
# > NA값을 무작정 삭제하는건 그다지 바람직한 방법은 아니다.
#   (데이터의 손실이 크다)
# 
# > NA값을 다른 값으로 대체해서 사용하는게 좋다.
#   (해당 컬럼의 평균값, 최소값, 최대값 등등등...)(간단한 경우)
# 

df <- data.frame(id=c(1,2,NA,4,NA,6),
                 score=c(20,30,NA,50,70,NA))
df

# 평균
mean(df$score)
# [1] NA

# > NA를 무시하고 연산하는 방법도 제공
#   (모든 함수가 이 옵션을 제공하진 않는다.)
mean(df$score, na.rm = T)
# [1] 42.5

# > score의 NA값을 score안에 있는 NA를 제거한 모든 값의 평균으로
#   대체해서 새로운 data frame을 만들어 사용한다.

df$score <- ifelse(is.na(df$score),mean(df$score, na.rm = T), df$score)
df
#   id score
# 1  1  20.0
# 2  2  30.0
# 3 NA  42.5
# 4  4  50.0
# 5 NA  70.0
# 6  6  42.5


########################################################
# 
# (결측치가 해결되었으면)
# 
# # 2. 이상치
# 
# > - 값이 없는것은 아닌데 사용할 수 없는 값이 포함된 경우
# > - 극단치값이 포함되어 있는 경우
# 

#
# 값이 없는것은 아닌데 사용할 수 없는 값이 포함된 경우
#
df <- data.frame(id=c(1,2,NA,4,NA,6),
                 score=c(20,30,NA,50,70,NA),
                 gender=c("M","F","M","F","M","F"))
df  # 정상값
# ------------------------------------------------------
df <- data.frame(id=c(1,2,NA,4,NA,6),
                 score=c(20,30,NA,50,70,NA),
                 gender=c("^^","F","M","F","M","F"),
#                       #  ㄴ 이상치
                 stringsAsFactors = F)
df


# 
# >   > 이상치는 일단 NA로 변환한 다음, NA를 처리하는 방식으로 진행
# 

df$gender <- ifelse(df$gender %in% c("M","F"),
                    df$gender,NA)
df
#   id score gender
# 1  1    20   <NA>
# 2  2    30      F
# 3 NA    NA      M
# 4  4    50      F
# 5 NA    70      M
# 6  6    NA      F

# 
# 극단치값이 포함되어 있는 경우
# (가중치가 붙어 결과에 큰 영향을 끼친다)
# (극단치에 대한 기준을 우리가 설정해야한다)
# (이 기준을 잡는 방법은 논리적으로 이성적인 범위를 설정)
# (통계적인 방법으로 이상적인 범위를 설정)
# 
