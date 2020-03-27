# R의 주석은 #을 이용한다.
# 여러줄 주석은 ctrl + shift + c
# ";"는 한 라인에 하나의 statement만 존재할 경우 생략 가능

a = 100
b = 200; c = 300

# 작성된 코드 실행은 ctrl + enter
# 인터프리터 방식이라 원하는 라인만 실행 가능하다

# 대소문자 구분한다.(case-sensitive)
# camel-case notation 추천
# weak type 언어 - 변수 선언시 type를 명시하지 않는다.
# "=", "->"를 이용해서 assignment를 수행

a = 100     # 사용 가능, 매우 드문 경우로 Error 발생
a <- 100    # 주로 사용(공식적)
200 -> a

# ~ mask ~
# Data Type(자료형), Data Structure(자료구조)
# Data Frame(자료형, table)(tomorrow)
# Vector  1차원, 같은 데이터 타입만 사용할 수 있다.
# Vector 중에 원소가 1개만 있는 Vector는 Scalar이다.
# R은 Index가 0이 아니라 1부터 시작한다.

# 변수의 값을 출력하려면
# - 해당 변수를 그대로 실행
# - print()를 이용해서 출력
# - 만약 여러개의 값을 출력하려면 cat()을 이용
# - file에 출력하려면 cat을 이용해 file option 사용
# - 만약 file 출력에서 파일안에 내용을 추가하려면
#   append=TRUE를 이용

myVar <- 100
result = myVar + 200

result
print(result)

cat("결과값은 : ", result, myVar, 
    file="C:/R_Workspace/R_Lecture/test.txt",
    append=TRUE)

#########################################################

# 기본적인 연산자는 다른 언어와 상당히 유사

var1 <- 100   # 정수 같지만 실수로 적용
var2 <- 3

result <- var1 / var2

result    # [1] 33.33333 (총 7개의 digit로 표현 - default)

options(digits = 5)   # digit 바꾸기
result    # [1] 33.333

# C와 Java처럼 format을 이용한 출력도 가능
sprintf("%.8f", result)   # [1] "33.33333333"

# 몫과 나머지
result = var1 %/% var2    # 몫
result    # [1] 33

result = var1 %% var2    # 나머지
result    # [1] 1

#########################################################

# 비교연산
# 다른 언어와 동일

var1 <- 100
var2 <= 200

var1 == var2    # [1] FALSE
var1 != var2    # [1] TRUE

#########################################################

# 논리연산
# 살짝 달라

# &, && >> 의미는 동일! (AND)
# |, || >> 의미는 동일! (OR)
# 1개와 2개 사용 시
# vector인지 scalar인지에 따라서 동작이 달라진다!
# R은 기본이 vector다
# scalar : vector의 길이가 1개인 것

TRUE & TRUE    # [1] TRUE
TRUE && TRUE    # [1] TRUE

# combine 함수를 이용해서 vector를 생성 >> c()
# vector의 인덱스는 0이 아닌 1부터 시작한다.
c(TRUE, FALSE)

# &
# 결과도 vector
c(TRUE, FALSE) & c(TRUE, TRUE)    # [1] TRUE FALSE
c(TRUE, FALSE) & c(TRUE, TRUE, FALSE)    # Error

## && >> 맨 처음에 있는 요소만 가지고 연산
# 결과가 scalar
c(TRUE, FALSE) && c(TRUE, TRUE)    # [1] TRUE
c(TRUE, FALSE) && c(TRUE, TRUE, FALSE)    # [1] TRUE

#########################################################

# 기본 함수들
# R Document 참조

abs(-3)         # 절대값      # 3
sqrt(4)         # 제곱근      # 2
factorial(4)    # factorial   # 24

#########################################################

# R의 데이터 타입!
# 1. nemeric(수치형) : 정수, 실수를 구분하지 않는다. (default : 실수)
#    100, 100.3 - 실수
#    10L        - 정수
# 
# 2. chracter(문자열) : 모든 글자는 문자열로 간주되고, 
#                       '', "" 혼용해서 사용이 가능하다.
# 
# 3. logical(논리형) : TRUE(T), FALSE(F)
#
# 4. complex(복소수형) : 4-3i

# 특수데이터 타입
# 1. NULL (java의 null과 유사) - 존재하지 않는 객체를 지칭할때 사용
# 2. NA (Not Available) - 유효하지 않은 값
#                       - 일반적으로 결측치를 표현할때 사용(missing value)
# 3. NAN (Not A Number) - 수치값이지만 숫자로 표현이 안되는 값
#                         ex) sqrt(-9)
# 4. Inf(Infinite) - 양의 무한대
#                    ex) 3 / 0

#########################################################

# R에서 제공하는 기본적인 함수 2가지
# 1. mode()          : data type
var1 <- 100
mode(var1)        # [1] "numeric"

# 2. is 계열의 함수
var2 = 300
is.numeric(var2)  # [1] TRUE
is.integer(var2)  # [1] FALSE   # 실수

#########################################################

# 데이터타입의 우선순위
# character > complex > mumeric > logical

# 기본적으로 사용되는 자료구조 : vector
myVar = c(10, 20, 30, 40)
myVar   # [1] 10 20 30 40

myVar = c(10, 20, 30, FALSE)
myVar   # [1] 10 20 30 0

myVar = c(10, "홍길동", 30, TRUE)
myVar   # [1] "10"     "홍길동" "30"     "TRUE"

# as 계열의 함수를 이용한 casting(형변환)
myVar = "100"
as.numeric(myVar)

# 데이터 타입
#########################################################

# R package

# R의 package는 처리할 Data + 기능(함수, 알고리즘)

# R의 package 시스템은
# 1. base System (R 설치 시 같이 설치되는 기본 package)
#    - base package (loading 과정이 필요없는 package)
#    - recommended package (설치는 되어있으나 loading은 필요한)
# 2. other package
#   

# 간단하게 package를 설치해보기
install.packages("ggplot2")

# package 삭제는
# remove.packages("ggplot2")

# 어디에 설치되는가?
.libPaths()
# [1] "C:/Users/student/Documents/R/win-library/3.6"  << 여기에!!
# [2] "C:/Program Files/R/R-3.6.3/library" 

# 설치위치 변경은?
# .libPaths("C:/myLib")

# package 설치 후 사용을 위해서는 메모리에 loading 해야 한다.
library(ggplot2)
# or
require(ggplot2)

myVar = c("남자", "여자", "여자", "여자", "여자", "남자")

qplot(myVar)

## 주의!
# 라이브러리 Error가 발생할 수 있다.(생각보다 잘!)
# R 설치 후에 .libPaths()를 이용해 2개의 경로가 나오는지 확인한다.
# 경로가 하나일 경우, .libPaths(__path__)를 사용해 별도의 경로를 추가해준다.

mean()
help(mean)
# help()를 이용해도 좋으나 RDocumentation.org 사이트를 이용하는게 더 좋다.

#########################################################

## 자 료 구 조

# 자료형은 저장된 데이터의 타입을 지칭
# 자료구조는 데이터가 메모리에 어떤 방식으로 저장되어있는가

## homogeneous - 자료구조 내부의 데이터 타입이 같은
# 
#  - 1. Vector  : 1차원 선형구조, 순서개념이 존재
#                같은종류의 데이터타입을 이용
#  - 2. Matrix  : 2차원 구조. 인덱스를 사용할 수 있다. (2차원 배열과 같다)
#                같은종류의 데이터타입을 이용
#  - 3. array   : 3차원 이상의 구조. 인덱스 사용 가능
#                같은종류의 데이터타입을 이용
# 
# 
## heterogeneous - 자료구조 내부의 데이터 타입이 다른
# 
#  - 1. list    : 1차원 선형구조. 순서개념 존재
#                실제 저장되는 구조는 map구조 (중첩자료구조)
#  - 2. data frame  : 2차원 테이블 구조
# 

##-----------------------------------------------------##

# Vector  : 1차원 선형자료구조. 순서개념
#           index를 이용하며, 시작이 1이다.
#           []를 이용해서 각 요소를 access할 수 있다.
#           요소가 1개인 vector >> scalar
#
myVar = c(100)    # myVar = 100

# vector를 만드는 방법
# 
# 1. combine() 함수를 사용 >> c()
#     - vector를 만드는 가장 대표적인 방법
#     - 2개 이상의 vector를 하나의 vector로 만들 때 사용할 수 있다.
#
myVar1 = c(10,20,30)
myVar2 = c(3.14,10,100)
myVar1    # [1] 10 20 30
myVar2    # [1]   3.14  10.00 100.00

result <- c(myVar1, myVar2)
result    # [1]  10.00  20.00  30.00   3.14  10.00 100.00

#-
# 2. ":"을 이용해서 만들기
#     - 수치형 데이터에만 사용할 수 있고 단조증가, 단조감소
#       형태의 vector를 생성
#
myVar <- 1:10   # (start:end)
myVar     # [1]  1  2  3  4  5  6  7  8  9 10

myVar <- 8.7:2
myVar     # [1] 8.7 7.7 6.7 5.7 4.7 3.7 2.7

#-
# 3. 2번의 일반형
#
myVar = seq(1,10,2)
myVar     # [1] 1 3 5 7 9

myVar = seq(from=10,to=3,by=-3)
myVar     # [1] 10  7  4

#-
# 4. 반복적인 값을 이용해서 vector 생성
#   rep()
#
myVar = rep(1:3, time=3)
myVar     # [1] 1 2 3 1 2 3 1 2 3

myVar = rep(1:3, each=3)
myVar     # [1] 1 1 1 2 2 2 3 3 3

# 많이 사용하는 함수 중 하나 : vector 안의 요소 갯수를 구하는 함수
myVar = c(10,20,30,40)
length(myVar)   # [1] 4

# vector 요소의 사용 (indexing 방식)
myVar = c(3.14,100,"Hello",TRUE,300)
myVar     # [1] "3.14"  "100"   "Hello" "TRUE"  "300"

myVar[1]      # [1] "3.14"
myVar[6]      # [1] NA
myVar[length(myVar)]    # [1] "300"

# slicing indexing
result <- myVar[2:4]
result        # [1] "100"   "Hello" "TRUE"

# fancy indexing
result <- myVar[c(2,3,5)]
result        # [1] "100"   "Hello" "300" 

myVar[-1]     # [1] "100"   "Hello" "TRUE"  "300"
              # index 1 빼고 나머지

myVar[-(3:4)] # [1] "3.14" "100"  "300"
              # index 3, 4 빼고 나머지

myVar[-c(1, 4, 5)]  # [1] "100"   "Hello"
              # index 1, 4, 5 제외

# vector 데이터에 이름 붙이기!
myVar = c(10,20,30,40,50)
myVar

names(myVar)    # NULL      # 이름 출력
names(myVar) = c("A","B","C","D","E")
names(myVar)    # [1] "A" "B" "C" "D" "E"

myVar
# A  B  C  D  E 
# 10 20 30 40 50

myVar[1]      #   # A
myVar["A"]        # 10

#########################################################

# vector 연산
myVar1 = 1:3    # [1] 1 2 3
myVar2 = 4:6    # [1] 4 5 6

result <- myVar1 + myVar2
result          # [1] 5 7 9

# recycle rule
myVar3 = 1:6    # [1] 1 2 3 4 5 6

result <- myVar1 + myVar3
result          # [1] 2 4 6 5 7 9     
                # (1 2 3 1 2 3) + (1 2 3 4 5 6)

# vector에 대한 집합연산(합집합, 교집합, 차집합)
var1 = 1:5            # [1] 1 2 3 4 5
var2 = 3:7            # [1]     3 4 5 6 7

union(var1,var2)      # [1] 1 2 3 4 5 6 7
intersect(var1, var2) # [1] 3 4 5
setdiff(var1,var2)    # [1] 1 2










