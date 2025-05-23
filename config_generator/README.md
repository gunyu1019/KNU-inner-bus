## KNU-inner-bus Config Generator
Flutter Application의 `assets/config/station.json`을 구성하기 위한 설정 구성 프로그램입니다.<br/>
KNU-inner-bus는 유지보수성(Maintaince)를 중시합니다. 다른 사용자가 애플리케이션을 구성할 수 있도록 설정 파일 구성 프로그램을 작성하였습니다.<br/>

애플리케이션의 계산 효율을 위해 `assets/config/station.json` 파일에는 정류장, 경로, 시간표를 모두 포함합니다.<br/>
`assets/config/station.json`를 구성하기 위한 **Config Generator**의 설정 파일은 아래와 같습니다.
* station.json : 정류장 정보
* timetable.csv : 정류장별 시간표
* waypoint.json : 구간별 경유지점


경로 데이터는 [카카오 모빌리티 길찾기 API](https://developers.kakaomobility.com/docs/navi-api/directions/)를 적용하였으며, 정류장 정보를 기반으로 최단거리를 기준으로 자동생성됩니다.<br/>

