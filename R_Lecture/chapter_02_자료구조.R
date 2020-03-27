## 3/9
#
## 데이터 분석
## R에서 EDA*(탐색적 데이터 분석)**
## - 주어진 데이터 안에서 내가 알고자하는 데이터를 추출
## - 데이터 내에 숨겨져 있는 특정한 사실을 유추하는 작업
#
## 통계적 가설 검정
#
## 머신러닝 -> 딥러닝으로 진행되는게 일반적인 수순
#
#
## R, RStudio 설치
#
## R Operator(연산자)
#
## R Data Type
## - nemeric
## - chracter
## - logical
## - complex
#
## R Package
## - base System
##    - base package
##    - recommended package
## - other package
#
## R Data Structure
## >> 6개의 자료구조가 존재
## - 같은 데이터 타입이 들어가는 자료구조
##    - 1차원 : Vector
##    - 2차원 : Matrix
##    - 3차원 이상 : Array
## - 다른 데이터 타입도 사용가능한 자료구조
##    - 1차원 : List
##    - 2차원 : Data Frame
##    - (Factor)(범주형)
#
## Vector
## 생성, 사용방법, 집합연산

##################################################################
#
# Today!  (3/10)
#
# - Matrix
# - Array
# - Data Frame
# - chracter << other package
# - I/O << external file
#
##################################################################
## 
## Matrix : 2차원 구조(행과 열로 구성)
##          같은 데이터 타입만 저장이 가능
## 
## * 생성 방법
##    - matrix() 함수
##    - cbind(), rbind() 함수
##

## 1. matrix() 함수를 이용해서 만들기

var1 <- matrix(c(1:5))
var1
#      [,1]   # 5행 1열
# [1,]    1
# [2,]    2
# [3,]    3
# [4,]    4
# [5,]    5

# nrow : 행
var1 <- matrix(c(1:10), nrow=2)
var1
#      [,1] [,2] [,3] [,4] [,5]   # 2행 5열
# [1,]    1    3    5    7    9
# [2,]    2    4    6    8   10

var1 <- matrix(c(1:11), nrow=2)
# Warning
# 경고메시지(들): 
#   In matrix(c(1:11), nrow = 2) :
#   데이터의 길이[11]가 행의 개수[2]의 배수가 되지 않습니다
var1
#      [,1] [,2] [,3] [,4] [,5] [,6]    # recycle rule
# [1,]    1    3    5    7    9   11
# [2,]    2    4    6    8   10    1

# byrow=TRUE  : 행 방향으로 데이터 채움(기본 열방향 데이터 채움)
var1 <- matrix(c(1:10), nrow=2, byrow = TRUE)
var1
#      [,1] [,2] [,3] [,4] [,5] 
# [1,]    1    2    3    4    5
# [2,]    6    7    8    9   10

#----------------------------------------------------------------#
# 
## 2. cbind(), rbind()를 이용해서 만들기
#

var1 <- 1:4
var2 <- 5:8
mat1 <- rbind(var1, var2)
mat1
#      [,1] [,2] [,3] [,4]
# var1    1    2    3    4
# var2    5    6    7    8

var1 <- 1:4
var2 <- 5:8
mat1 <- cbind(var1, var2)
mat1
#      var1 var2
# [1,]    1    5
# [2,]    2    6
# [3,]    3    7
# [4,]    4    8

##################################################################
## 

var1 <- matrix(c(1:10), nrow=2, byrow = TRUE)
#      [,1] [,2] [,3] [,4] [,5] 
# [1,]    1    2    3    4    5
# [2,]    6    7    8    9   10

# 일반적인 2차원 indexing 방법과 동일
var1[1,4]     # [1] 4

# 모든행에 대해서 4열을 가져오기
# 결과는 vector로 return
var1[,4]        # [1] 4 9

var1[1,]        # [1] 1 2 3 4 5

var1[length(var1)]    # [1] 10

##

length(var1)    # [1] 10    # 전체 요소(원소)의 갯수
nrow(var1)      # [1] 2     # 행의 갯수
ncol(var1)      # [1] 5     # 열의 갯수

##################################################################
# 
# 3차원 Array 만들기
# 

var1 <- array(c(1:24))
var1    #  [1]  1  2  3  4  5  .....

var1 <- array(c(1:24),
              dim = c(3,2,4))
#                    행,열,면
var1
# , , 1               # 면
# 
#      [,1] [,2]
# [1,]    1    4
# [2,]    2    5
# [3,]    3    6
# 
# , , 2
# 
#      [,1] [,2]
# [1,]    7   10
# [2,]    8   11
# [3,]    9   12
# 
# , , 3
# 
#      [,1] [,2]
# [1,]   13   16
# [2,]   14   17
# [3,]   15   18
# 
# , , 4
# 
#      [,1] [,2]
# [1,]   19   22
# [2,]   20   23
# [3,]   21   24

##################################################################
## 
## R Factor 
## > factor는 범주형
##    방의 크기(대, 중, 소) -> level
## 
## 명목형과 순서형이 있다.
## level에 순서개념이 없으면 명목형(좌,우)
##                    있으면 순서형(대,중.소)
##

#
# factor 생성 
# > vector를 이용해서 만든다 
# 

var1 <- c("A","B","AB","O","A","AB")
var1    # [1] "A"  "B"  "AB" "O"  "A"  "AB"

var1_factor <- factor(var1)
var1_factor
# [1] A  B  AB O  A  AB
# Levels: A AB B O            # 순서 개념 x : 명목형

# factor의 level만 출력
levels(var1_factor)           # [1] "A"  "AB" "B"  "O" 

#
# 일반적으로 factor를 생성하는 방법
#

var1 <- c("A","B","AB","O","A","AB")
var1_factor <- factor(var1,
                      levels = c("A","B","O","AB"),
                      ordered=TRUE)
var1_factor
# [1] A  B  AB O  A  AB
# Levels: A < B < O < AB

# !
var1_factor <- factor(var1,
                      levels = c("A","B","O"))
var1_factor
# [1] A    B    <NA> O    A    <NA>
# Levels: A B O

##################################################################
## 
## List
## > 1차원 선형구조
## > 여러 형태의 자료형이 같이 저장될 수 있다.
## > 각 index 위치에 값이 저장될 때 map 형태로 저장된다. (key, value)
## 

var1_scalar <- 100
var2_vector <- c(10,20,30)
var3_matrix <- matrix(c(1:6), nrow=3)

myList <- list(var1_scalar,var2_vector,var3_matrix)
myList
# [[1]]             # key
# [1] 100           # value
# 
# [[2]]
# [1] 10 20 30
# 
# [[3]]
#      [,1] [,2]
# [1,]    1    4
# [2,]    2    5
# [3,]    3    6

myList[[1]]         # [1] 100
myList[[2]][3]      # [1] 30

#
## 전형적인 list 생성 방법
#

#              key    value
myList <- list(names =c("홍길동","김길동"),
               age   =c(20,30),
               gender=c("남자","여자"))
myList
# $names                    # key
# [1] "홍길동" "김길동"     # value
# 
# $age
# [1] 20 30
# 
# $gender
# [1] "남자" "여자"

#
## access
#

myList$age        # key
# [1] 20 30

myList[[2]]       # index
# [1] 20 30

myList[["age"]]   # key
# [1] 20 30

# 기본적인 자료구조에 대한 사용법
##################################################################
## 
## Data Frame
##
## > R에서 가장 많이 쓰이고 가장 중요한 자료구조
## > 행과 열로 구성된 2차원 형태의 테이블
## > matrix와 달리 coloum 명이 존재!
## > Database의 Table과 같은 구조
## > 컬럼 단위로 서로 다른 타입의 데이터 저장이 가능
## 

#                coloum  value
df <- data.frame(NO    = c(1,2,3),
                 Name  = c("홍길동","이순신","강감찬"),
                 Age   = c(20,30,40))
df
#   NO   Name Age
# 1  1 홍길동  20
# 2  2 이순신  30
# 3  3 강감찬  40

View(df)    # View 창을 이용해서 data frame 확인 가능

#
df$Name     # coloum name     # return factor
# [1] 홍길동 이순신 강감찬
# Levels: 강감찬 이순신 홍길동
#
# > 문자열은 기본적으로
# > factor 형태로 자동 저장
# >
# > vector 형태로 저장하고싶다면

df <- data.frame(NO    = c(1,2,3),
                 Name  = c("홍길동","이순신","강감찬"),
                 Age   = c(20,30,40),
                 stringsAsFactors=FALSE)  # *옵션 추가*
df$Name
# [1] "홍길동" "이순신" "강감찬"

# 
# data frame중 일부를 추출해서
# 다른 data frame을 생성할 수 있다.
# 

df <- data.frame(x=c(1:5),
                 y=seq(2,10,2),
                 z=c("a","b","c","d","e"),
                 stringsAsFactors=FALSE)
df
#   x  y z
# 1 1  2 a
# 2 2  4 b
# 3 3  6 c
# 4 4  8 d
# 5 5 10 e

# 
# x의 값이 3 이상인 행만 추출
# 

subset1 <- subset(df, x>=3)
subset1
#   x  y z
# 3 3  6 c
# 4 4  8 d
# 5 5 10 e

# 
# x의 값이 3 이상, y값이 8 이하인 행만 추출
# 

subset1 <- subset(df, x>=3 & y<=8)
subset1
#   x y z
# 3 3 6 c
# 4 4 8 d

##################################################################
# 
## 연습문제 
# 
## 1. 4,5,7,8,10,3 의 숫자를 이용해서 숫자벡터 x를 생성하세요!!
# 
x <- c(4,5,7,8,10,3)
x   # [1]  4  6  7  8 10  3

# 
## 2. 다음 연산을 수행한 결과는?
##    x1 <- c(3,5,7,9)
##    x2 <- c(3,3,3)
##    x1 + x2 = ? 
# 
# [1] 6 8 10 12           # recycle rule 적용

# 
## 3. data frame과 subset을 이용해서 다음의 결과를 만들어보아라. 
# 
Age <- c(22,25,18,20)
Name <- c("홍길동","최길동","박길동","김길동")
Gender <- c("M","F","M","F")

# 3-1. 위 3개의 vector를 이용하여 Data Frame을 생성하고
# 3-2. subset을 이용하여 다음의 결과를 출력한다.
#      Age  Name    Gender
#      22   홍길동  M
#      18   박길동  M

# 3-1
myDf <- data.frame(Age = c(22,25,18,20),
                   Name = c("홍길동","최길동","박길동","김길동"),
                   Gender = c("M","F","M","F"))
myDf <- data.frame(Age = Age,
                   Name = Name,
                   Gender = Gender,
                   stringsAsFactors=FALSE)
myDf

# 3-2
subset(myDf, Gender=="M")


# 
## 4. 다음의 R 코드를 실행시킨 결과는 무었일까요? 
# 
x <- c(2,4,6,8)
y <- c(T,F,T,F)     # locical vector

x[1]  # [1] 2
x[y]  # [1] 2 6

# > Boolean indexing
# > - TRUE 위치의 값은 남기고 나머지는 지우는 방식.
# > - 두 vector의 사이즈가 같아야 한다.

x[c(1,2,4)]   # [1] 2 4 8

# > fancy indexing 
# > - 지정한 위치의 값만 남기고 나머지는 지우는 방식.

x[1]          # indexing
x[1:3]        # slicing
x[y]          # boolean indexing
x[c(1,2,4)]   # fancy indexing

##

sum(x[y])     # [1] 8
              # sum(), mean(), max(), min().... 기본 수학 함수

# 
## 5. 아래의 계산결과는?
# 
x <- c(1,2,3,4)
(x+2)[(!is.na(x)) & x>2] -> k
k       # [1] 5 6

# > x+2
# [1] 3 4 5 6
#
# > is.na(x)
# [1] FALSE FALSE FALSE FALSE
#
# > (!is.na(x)) & x>2
# [1] FALSE FALSE  TRUE  TRUE

# 
## 6. 결측치(missing value) -> NA
##     > 데이터 분석을 위해서는 반드시!
##     > NA 값을 없애거나 다른 값으로 바꿔주어야 한다.
# 
x <- c(10,20,30,NA,40,50,60,NA,NA,100)
#
##     이 vector 안에 결측치는 몇개가 있는가?
#
is.na(x)          # [1] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE
sum(is.na(x))     # [1] 3       # FALSE : 0  // TRUE : 1

##################################################################