# 
# 데이터 분석을 이용하려면
# 웹 데이터 분서이 가장 많이 않을까 생각된다.
# log data 등등 >> 의사결정에 반영하는 방식으로 이용
# : 마케팅 목적으로 많이 사용
# : 추천 시스템
# 

#
# ## Graph에 대해서 알아보자.
# 
# ggplot2 package를 사용
# 2차원 그래프를 그리는 방법
# 

library(ggplot2)
mpg

df <- as.data.frame(mpg)    # table >> data frame 변환
df

# # ggplot2 package의 그래프를 그리는 방식
# 
# > 1. 배경설정(x, y축 설정)
# > 2. 실제 그래프를 추가(선, 막대, 점)
# > 3. 축 범위, 색과 같은 설정 추가
# 

# 
# # 1. 산점도(scatter plot)
# >   2차원 평면(x, y축)에 점으로 표현한 그래프
# 

# 배기량과 고속도로 연비의 관계를 알아보자
# 축 설정
ggplot(data = df,
       aes(x=displ,y=hwy))

# 그래프 종류
ggplot(data = df,
       aes(x=displ,y=hwy)) +
  geom_point()    # 산점도

# 추가 설정
ggplot(data = df,
       aes(x=displ,y=hwy)) +
  geom_point() +
  xlim(3,6) + ylim(20,40)   # 그래프의 일부 범위


# 
# # 2. 막대그래프
# >   일반적으로 두 집단간의 차이를 볼 때
# 

# 구동방식별 고속도로 연비차이를 비교해보자
# 데이터를 구동방식별 grouping > 평균연비
library(rvest)
library(stringr)
library(dplyr)

result <- df %>% 
          group_by(drv) %>%
          summarise(mean_hwy=mean(hwy))
result
# # A tibble: 3 x 2
#   drv   mean_hwy
#   <chr>    <dbl>
# 1 4         19.2
# 2 f         28.2
# 3 r         21 

# 그래프
ggplot(data = result,
       aes(x=drv,y=mean_hwy)) +
  geom_col()      # 막대그래프


# 
# # 3. boxplot
# >
# 

# 구동방식별 고독도로 연비차이 비교
ggplot(data = df,
       aes(x=drv,y=hwy)) +
  geom_boxplot()        # point : 이상치

# 
# 
# 사분위
# 전체 수량의 비율
# 
#             6개    2사분위     6개
#                       v
data <- c(1,2,3,4,5,6,  7  ,8,9,10,11,12,50)
mean(data)    # [1] 9.846154


#
############################################################## 
# 
# 문자열처리(word cloud)
# 한글 형태소 분석
# 형태소(뜻을 가진 가장 작은 단위)
# 
# 특정 영화에 대한 comment들을 모아서 표현해보자
# comment를 모아 형태소를 분석한 후
# word cloud를 작성한다
# 

# 
# 한글 형태소를 분석하기 위해서는 특수한 package가 필요하다.
# > KONLP(Korean Natural Language Process)
# 

install.packages("KONLP")
# Warning in install.packages :
# package ‘KONLP’ is not available (for R version 3.6.3)

# 현재 CRAN에서 설치가 불가능한 상황
# (라이브러리 목록에서 제외된 상태로 생각됨)
.libPaths()
# KONLP 관련 폴더를 위의 결과 링크에 복사.

library(KoNLP)
# 필요 패키지들을 별도로 설치
# install.packages("Sejong")
# install.packages("hash")
# install.packages("tau")
# install.packages("RSQLite")
# install.packages("devtools")

# 사용할 수 있는 한글 사전은 3가지 종류
# 시스템, 세종, NIADIC
useNIADic()     # 한글사전 선택

tmp <- "이것은 소리없는 아우성"

extractNoun(tmp)

#
library(stringr)
txt <- readLines("data/hiphop.txt", encoding = "UTF-8")
txt

words <- extractNoun(txt)     # return list
result <- unlist(words)       # list to vector
result

# 빈도 구하기
# table()
wordcount <- table(result)
wordcount

wordcount_df <- as.data.frame(wordcount, stringsAsFactors = F)
wordcount_df

# 한 단어, 빈도 낮은 단어 제외
word_df <- wordcount_df %>%
    filter(nchar(result) >= 2) %>%
    arrange(desc(Freq)) %>%
    head(20)
word_df

# Word Cloud Package
install.packages("wordcloud")
library(wordcloud)

# 단어 색상 목록 설정
pal <- brewer.pal(8,"Dark2")
pal <- brewer.pal(8,"RdBu")
pal <- brewer.pal(8,"Paired")

# wordcloud는 생성할 때마다 다르게 생성
# 만약 같은 형태의 wordcloud를 생성하고 싶다면
# random 대신 seed값을 설정
set.seed(1)

# 
wordcloud(words = word_df$result,     # 사용할 단어*
          freq = word_df$Freq,        # 빈도수*
          min.freq = 2,               # 최소 빈도수
          max.words = 200,            # 사용할 단어들의 최대 갯수
          random.order = F,           # 고빈도 단어는 중앙
          rot.per = 0.1,              # 글자 회전
          colors = pal)


############################################################## 
# 
# 복습, 정리
#
# 1. 데이터 분석 -> R
#   데이터 타입, 데이터 구조(자료구조)
# 
# 2. 데이터 수집
#   - file로부터 데이터 받아오기
#   - 웹프로그램으로 JSON 받아오기
#   - Open API를 이용해서 JSON 받아오기
#   - Scraping & Crawling (selector / xpath)
#   
# 3. 데이터 전처리(NA, 이상치 처리)
# 
# 4. 데이터 분석
#   - dplyr을 이용한 data frame 처리
#   - EDA(탐색적 데이터 분석)
#   - 주어진 데이터 안에서 요구되는 데이터 추출하는 방법 연습
#   - 공공데이터(일반적인 raw 데이터)를 이용해 의미있는 데이터 추출
#       ㄴ 이건 안했다
# 
# 
# ------------------------------------------------------------
# 
# 누적 문제 해걸 (수행평가)
# 
# 1. mpg data set을 이용한 8개 문제 해결(dplyr)
#     (EDA 시작점)
# 
# 2. 웹 스크래핑(로튼토마토)
# 
# 3. 네이버 영화 댓글 사이트에서
#     특정 영화에 대한 댓글을 수집하여 wordcloud를 생성
# 
# ------------------------------------------------------------
# 
# 네이버 영화 댓글 - wordcloud
# 
# 다크워터스
# https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=190728&target=&page=1
#
# 인비저블맨
# https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=189001&target=&page=2
# 
library(rvest)
library(stringr)

url <- "https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=190728&target=&page="
url <- "https://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=189001&target=&page="

movie_contents <- vector(mode = "character", length = 1000)

for (i in 1:100) {
  request_url <- str_c(url,i)
  page_html <- read_html(request_url, encoding = "CP949")
  
  nodes <- html_nodes(page_html, "td.title")
  page_content <- html_text(nodes)
  
  for (j in 1:10) {
  # for (j in 1:length(page_content)) {
    page_content[j] <- str_remove_all(page_content[j], "신고")
    page_content[j] <- str_remove_all(page_content[j], "\t")
    page_content[j] <- str_split(page_content[j], "\n")
    movie_contents[(i-1)*10+j] <- page_content[j][[1]][11]
  }
    
  # for (j in 1:length(page_content)) {
  #   temp <- str_remove_all(page_content[j], "\t")
  #   temp <- str_remove_all(temp, "신고")
  #   temp <- str_split(temp, "\n")
  #   movie_contents[(i-1)*10+j] <- temp[[1]][11]
  # }
}

movie_contents

# 
library(KoNLP)
library(dplyr)
library(wordcloud)

useNIADic()
words <- extractNoun(movie_contents)
result <- unlist(words)

wordcount <- table(result)
wordcount_df <- as.data.frame(wordcount, stringsAsFactors = F)

# 한 단어, 빈도 낮은 단어 제외
word_df <- wordcount_df %>%
  filter(nchar(result) >= 2) %>%
  arrange(desc(Freq))
word_df


pal <- brewer.pal(8,"Paired")
set.seed(1)

wordcloud(words = word_df$result,     # 사용할 단어*
          freq = word_df$Freq,        # 빈도수*
          min.freq = 2,               # 최소 빈도수
          max.words = 200,            # 사용할 단어들의 최대 갯수
          random.order = F,           # 고빈도 단어는 중앙
          rot.per = 0.1,              # 글자 회전
          colors = pal)

warnings()
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 