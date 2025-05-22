## KNU-inner-bus Config Generator
Flutter Application의 `assets/config/station.json`을 구성하기 위한 설정 구성 프로그램입니다.
KNU-inner-bus는 유지보수성(Maintaince)를 중시합니다. 다른 사용자가 애플리케이션을 구성할 수 있도록 설정 파일 구성 프로그램을 작성하였습니다.

애플리케이션의 계산 효율을 위해 `assets/config/station.json` 파일에는 정류장, 경로, 시간표를 모두 포함합니다.
**Config Generator**의 구성 파일은 아래와 같습니다.
* station.json : 정류장 정보
* timetable.csv : 정류장별 시간표
경로 데이터는 정류장 정보를 기반으로 자동생성됩니다.
