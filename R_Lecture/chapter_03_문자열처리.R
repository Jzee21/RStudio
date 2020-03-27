# 
## 빅데이터 처리에서 문자열처리는 꽤나 빈번하게 발생하는 작업이다.
# 
## 기본적인 R의 base system을 이용해서 문자열을 처리하는것은
## 그다지 좋은 방식은 아니다.
# 
##문자열처리에 대한 대표적인 package가 있다.
# 
## > stringr < ## 
# 
# 1. package install
install.packages("stringr")

# 2. package loading
library(stringr)        # or  require(stringr)

# 3. using!
myStr <- "Hongkd1051Leess4504YOU25홍길동1004"

# stringr func          # stringr   : str_*
# 1. 문자열의 길이
str_length(myStr)       # [1] 31

# 2. 찾고자 하는 문자열의 시작위치와 끝위치
str_locate(myStr, "Lee")
#      start end
# [1,]    11  13

str_locate(myStr, "0")
#      start end
# [1,]     8   8

str_locate_all(myStr, "0")
# [[1]]             # list
#      start end    # matrix
# [1,]     8   8
# [2,]    18  18
# [3,]    29  29
# [4,]    30  30

# 3. 부분 문자열
str_sub(myStr, 2, 5)    # [1] "ongk"

# 4. 모두 대문자/소문자로
str_to_upper(myStr)     # [1] "HONGKD1051LEESS4504YOU25홍길동1004"
str_to_lower(myStr)     # [1] "hongkd1051leess4504you25홍길동1004"

# 5. 문자열 교체
str_replace(myStr, "홍길동", "신사임당")    # [1] "Hongkd1051Leess4504YOU25신사임당1004"

# 6. 문자열 결합
str_c(myStr, "이순신2020")      # [1] "Hongkd1051Leess4504YOU25홍길동1004이순신2020"

# 7. 문자열 분리
myStr <- "Hongkd1051,Leess4504,YOU25,홍길동1004"
str_split(myStr, ",")           # vector로 return?
# [[1]]
# [1] "Hongkd1051" "Leess4504"  "YOU25"      "홍길동1004"

##################################################################
# 
## R 정규식(regular expression)
# 
# > 약속된(정해져있는) 기호를 이용해서 의미를 표현
# 
myStr <- "Hongkd1051,Leess4504,YOU25,홍길동1004"

# stringr에 정규식을 이용하여 내가 원하는 형태의 문자열을 추출하는 함수가 있다.
str_extract_all(myStr, "[a-z]{3}")
#               target  en   cnt  반복 3개인것
# [[1]]
# [1] "ong" "ees"

str_extract_all(myStr, "[a-z]{3,}")   # 3번 이상
# [[1]]
# [1] "ongkd" "eess"

str_extract_all(myStr, "[a-z]{3,4}")   # 3번 이상 5 미만
# [[1]]
# [1] "ongk" "eess"

#                       unicode
str_extract_all(myStr, "[가-힣]{3}")    # 한글 3글자자
# [[1]]
# [1] "홍길동"

str_extract_all(myStr, "[0-9]{4}")
# [[1]]
# [1] "1051" "4504" "1004"

str_extract_all(myStr, "[^a-z]{3}")     # 소문자가 아닌것
# [[1]]
# [1] "105"   "1,L"   "450"   "4,Y"   "OU2"   "5,홍"  "길동1" "004"  

##################################################################
# 
## 데이터 입출력
# 
# > 데이터 분석을 하기 위해서는 가장 먼저 데이터를 준비해야한다.
# > 1. 키보드를 이용해 데이터를 입력받기.
#      scan(), edit()
#
myNum = scan()      # 숫자만 입력가능
myNum
# > myNum = scan()
# 1: 100
# 2: 200
# 3: 300
# 4: 
#   Read 3 items
# > myNum
# [1] 100 200 300

myData = scan(what=character())    # 문자 입력
myData
# > myData = scan(what=character())
# 1: 홍길동
# 2: 
#   Read 1 item
# > myData
# [1] "홍길동"

# 
# > 만약 data frame에 데이터를 직접 임력하고 싶다면?
# 
df = data.frame()
my_df = edit(df)
my_df


# 
# > 2. file에 있는 데이터 읽기
#      read.table()                 student_midterm 
#
df <- read.table("data/student_midterm.txt", sep = ",")
df
#   V1 V2  V3  V4
# 1  1  1  39 100
# 2  2  1 100  30
# 3  3  4  50  50
# 4  4  4 100  90
# 5  5  3  90  80

#
## * file에 header가 포함되어 있는 경우
#
df <- read.table("data/student_midterm.txt", 
                 sep = ",", 
                 header = TRUE, 
                 fileEncoding = "UTF-8")
df
#   학번 학년 국어 영어
# 1    1    1   39  100
# 2    2    1  100   30
# 3    3    4   50   50
# 4    4    4  100   90
# 5    5    3   90   80

#
## * file 탐색기에서 file을 선택할 수 있다.
#
df <- read.table(file.choose(), sep = ",")

# 
## > 만약 file에 이상데이터가 있는 경우
# 
df <- read.table("data/student_midterm_na.txt", 
                 sep = ",", 
                 header = TRUE, 
                 fileEncoding = "UTF-8",
                 na.strings = "-")
df
#   학번 학년 국어 영어
# 1    1    1   39  100
# 2    2    1  100   30
# 3    3    4   50   NA
# 4    4    4   NA   90
# 5    5    3   90   NA

##################################################################
# 
## 데이터 교환, 전달할 때 사용하는 데이터 표준형식
# 
# > 1. CSV(Comma Seperated Value) 방식
#       - csv 파일
#       - 예 : 1,1,39,100,......
#       - 장점 : 용량이 작아 - 대용량 데이터 전달에 유리
#       - 단점 : 데이터의 구조화가 힘듬.(부가적인 데이터가 필요)
#                파서를 데이터에 따라 수정이 필요
# 
# > 2. XML(Extended Markup Language) 방식
#       - 예 : <name>홍길동</name><age>20</age>.....
#       - 장점 : 데이터 구조화가 간편. 파싱이 간편
#       - 단점 : 데이터 용량이 너무크게 증가
# 
# > 3. JSON(JavaScript Object Notation)
#       - 예 : { name:"홍길동", age:20, addr:"a"....}
#       - 장점 : 데이터 구조화 간편, 용량 감소
# 
##################################################################
# 
## read.csv()
##  - read.table()과 유사
##  - header=TRUE : default
##  - sep=","     : default
# 
df <- read.csv("data/student_midterm.csv", fileEncoding = "UTF-8")
df

# 
## excel 파일로 데이터 파일이 되어있는 경우
## 기본기능으로는 불가능하고, 외부 package를 이용해야한다.
# 
install.packages("xlsx")
require("xlsx")

#
df <-read.xlsx(file.choose(),
               sheetIndex = 1,
               encoding = "UTF-8")
df

class(df)     # [1] "data.frame"    # data structure

##################################################################
# 
## file에 data frame 저장
# 
# > write.table()
# 
write.table(df,
            file = "data/result.csv",
            row.names = FALSE,
            quote = FALSE)
# row.names : index 출력 x
# quote     : "" x

##################################################################
# 
## R에서 JSON 처리
# 
# > JSON 데이터를 어디서 가저오는가.
#   - 1. DB setting, 간단한 Servlet을 이용해 JSON을 받아온다.
#   - 2. OPEN API(영화진흥위원회 OPEN API)(나중에)
# 
# 

# 
## 도서검색 프로그램을 이용해서 JSON을 이용해보기 
# 
# > DB Setting
#   1. MySQL(standalone)
#   2. bin\mysql 실행(demon)   cmd - mysqld
#   3. new cmd - cd ...../bin
#       > mysql -u root
#   4. 유저 생성
#       > create user book identified by "book";
#       > create user book@localhost identified by "book";
#   5. DB 생성
#       > create database library;
#   6. DB 권한설정
#       > grant all privileges on library.* to book;
#       > grant all privileges on library.* to book@localhost;
#   7. 권한 적용
#       > flush privileges;
#   8. cmd에서 나가기
#       > exit
#       bye
#   9. 제공된 script을 이용해 DB 구축
#       - `_BookTableDump.sql` file 을 .../bin 경로에 복사.
#       - cmd
#         > mysql -u book -p library < _BookTableDump.sql
# 
##################################################################
# 
# # R에서 외부 Web Application을 호출하여 결과를
# # Data Frame으로 받기.
# 
# # 결과로 얻은 JSON -> Data Frame으로 변환하기.
# # 외부 package를 사용한다.
# 
install.packages("jsonlite")
install.packages("curl")
require(jsonlite)       # JSON 처리를 위해
require(stringr)        # 문자열 처리를 위해
require(curl)

# 
# # http://localhost:8080/bookSearch/search?keyword=
# 
url <- "http://localhost:8080/bookSearch/search?keyword="

request_url <- str_c(url, scan(what=character()))
request_url

df <- fromJSON(request_url)

View(df)
# 
# 
df$title

for (i in 1:nrow(df)) {
  print(df$title[i])
}

# 
# # 외부 API를 이용하여 JSON을 획득해 결과 출력.
# 
# # 영화진흥위원회 OPEN API 사용.
# 
# # http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=842757566eabba4c15bbf6b73598b97f&targetDt=20200310
# 
# 

mUrl <- "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=842757566eabba4c15bbf6b73598b97f&targetDt="

request_mUrl <- str_c(mUrl, "20200310")
request_mUrl

mdf <- fromJSON(request_mUrl)
mdf
View(mdf)

# my
mdf <- mdf$boxOfficeResult$dailyBoxOfficeList

mdf
View(mdf)

# prof
mdf[[1]]
mdf[["boxOfficeResult"]]
mdf[["boxOfficeResult"]][["dailyBoxOfficeList"]]

# 
# 
# 
wUrl <- "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=AbJoP9SJs6N2YUUVHIZmETyEHDN0zvFnQfsaqJiIX7Vc8aaOfeIWLaCUI16d%2FAzzOgxpgzrCtQZU8Gyw%2B5QI%2FQ%3D%3D&base_date=20200311&base_time=1100&nx=61&ny=125&numOfRows=160&pageNo=1&dataType=json"

wdf <- fromJSON(wUrl)
wdf_items <- wdf$response$body$items$item
View(wdf$response$body$items)
View(wdf_items)

# 