library(shiny)
library(shinyWidgets)
library(bs4Dash)
library(echarts4r)
library(shinyjs)
library(digest)

library(rjson)
library(DT)
library(ggplot2)
library(RColorBrewer)
library(lubridate)
library(dplyr)
library(plotly)

rawdata<-rjson::fromJSON(file="https://api.covid19india.org/raw_data.json")

json_file_raw <- lapply(rawdata[["raw_data"]], function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

df<-as.data.frame(do.call("rbind", json_file_raw))
df<-df[df$dateannounced!="",]

datafile<-cbind.data.frame(df[13],df[18],df[5],df[1],df[10],df[6],df[7],df[8],df[17],df[4],
                           df[12],df[3],df[11],df[20],df[19],df[14],df[15],df[16],df[2])
colnames(datafile)<-c("Patient Number",
                      "State Patient Number", 
                      "Date Announced" ,
                      "Age Bracket" ,
                      "Gender" ,
                      "Detected City", 
                      "Detected District", 
                      "Detected State" ,
                      "State_Code",
                      "Current Status" ,
                      "Notes" ,
                      "Contracted from which Patient (Suspected)", 
                      "Nationality",
                      "Type of transmission",
                      "Status Change Date",
                      "Source_1",
                      "Source_2",
                      "Source_3",
                      "Backup Notes")


y <- as.Date(datafile$`Date Announced`,"%d/%m/%Y")
x1 = data.frame(date = c(y))
x1 = x1 %>% 
  mutate(date = ymd(date)) %>% 
  mutate_at(vars(date), funs(year, month, day))
head(x1)
datafile<-cbind(datafile,x1[,-2])

datafile$`Detected State`<-as.character(datafile$`Detected State`)
datafile$`Detected State`<-replace(datafile$`Detected State`,datafile$`Detected State`=="","UNKNOWN")

datafile$`Detected District`<-as.character(datafile$`Detected District`)
datafile$`Detected District`<-replace(datafile$`Detected District`,datafile$`Detected District`=="","UNKNOWN")

datafile$`Detected City`<-as.character(datafile$`Detected City`)
datafile$`Detected City`<-replace(datafile$`Detected City`,datafile$`Detected City`=="","UNKNOWN")

#datafile<-datafile[,-1]
#write.csv(datafile,"Patient_Details.csv",row.names = FALSE)



DailyCount<-rjson::fromJSON(file="https://api.covid19india.org/data.json")


json_file_daily <- lapply(DailyCount[["cases_time_series"]], function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

daily_data<-as.data.frame(do.call("rbind", json_file_daily))



y <- as.Date(daily_data$date,"%d %b")
x1 = data.frame(date = c(y))
x1 = x1 %>% 
  mutate(date = ymd(date)) %>% 
  mutate_at(vars(date), funs(year, month, day))
head(x1)
date_format<-x1$date
daily_data<-cbind(date_format,daily_data)



json_file_state <- lapply(DailyCount[["statewise"]], function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

Statewise_data<-as.data.frame(do.call("rbind", json_file_state))



SDWV1<-rjson::fromJSON(file="https://api.covid19india.org/state_district_wise.json")

SDWV2<-rjson::fromJSON(file="https://api.covid19india.org/v2/state_district_wise.json")





totalconfirmed<-Statewise_data[1,"confirmed"]
totalactive<-Statewise_data[1,"active"]

totalrecovered<-Statewise_data[1,"recovered"]
totaldeceased<-Statewise_data[1,"deaths"]

todayconfirmed<-Statewise_data[1,"deltaconfirmed"]
todayrecovered<-Statewise_data[1,"deltarecovered"]
todaydeaths<-Statewise_data[1,"deltadeaths"]

daily_river<-daily_data[33:dim(daily_data)[1],1:4]
cum_river<-daily_data[33:dim(daily_data)[1],-2:-5]







state_data<-Statewise_data
jam<-as.numeric(levels(state_data[state_data$state=="Ladakh","confirmed"]))[state_data[state_data$state=="Ladakh","confirmed"]]+
  as.numeric(levels(state_data[state_data$state=="Jammu and Kashmir","confirmed"]))[state_data[state_data$state=="Jammu and Kashmir","confirmed"]]

statedata<-state_data[Statewise_data$state!="Ladakh",]
statedata<-statedata[statedata$state!="Total",]

State_data<-cbind(NAME_1=data.frame(statedata$state),Confirmed=data.frame(as.numeric(levels(statedata$confirmed))[statedata$confirmed]))
State_data <- State_data[order(State_data[,1],decreasing = F),]
State_data<-data.frame(cbind(as.factor(c(1:36)),State_data))
colnames(State_data)<-c("id","State","Confirmed")
State_data[State_data$State=="Jammu and Kashmir","Confirmed"]<-jam

bf<-data.frame(Statewise_data)
bf<-cbind(bf[,"state"],bf[,"confirmed"],bf[,"active"],bf["recovered"],bf[,"deaths"])
colnames(bf)<-c("STATE/UT","CONFIRMED","ACTIVE","RECOVERED","DECEASED")

Dist_Count<-datafile%>%
  group_by(`Detected State`,`Detected District`)%>%
  summarize(Confirmed=n_distinct(`Patient Number`))
Dist_Count<-Dist_Count[-1,]
Dist_daily_Count<-datafile[datafile$`Date Announced`==tail(unique(datafile$`Date Announced`),n=1),]%>%
  group_by(`Detected State`,`Detected District`)%>%
  summarize(Confirmed=n_distinct(`Patient Number`))

district_wise<-data.frame(merge(Dist_Count,Dist_daily_Count,by=c("Detected State","Detected District"), all.x=TRUE))
colnames(district_wise)<-c("State","District","Confirmed","Today")
district_wise$Today[is.na(district_wise$Today)]<-0

timeline<-data.frame(tail(daily_data[,2:5],n=4))












