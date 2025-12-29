# Plugin Module Rules

---

## main.py
- 역할: 플러그인 진입점, CollectorPluginServer 라우트 정의
- 금지: 비즈니스 로직 구현, 직접 API 호출
- 규칙:
  - `CollectorPluginServer` 인스턴스 생성
  - 4개 라우트 필수: `Collector.init`, `Collector.verify`, `Collector.collect`, `Job.get_tasks`
  - Manager를 호출하여 수집 위임
  - config에서 메타데이터 설정값 import

---

## config/
- 역할: 전역 설정값, 상수 정의
- 파일명: `{용도}_conf.py` (예: `global_conf.py`, `connector_conf.py`)
- 금지: 로직 구현, 다른 모듈 import
- 허용 import: 표준 라이브러리만
- 규칙:
  - `global_conf.py`: REGION_INFO, ICON_URL, SUPPORTED_* 상수
  - `connector_conf.py`: API 엔드포인트, 타임아웃 설정
  - 모든 상수는 UPPER_SNAKE_CASE

---

## connector/
- 역할: 외부 API 통신, Raw 데이터 수집
- 파일명: `{service}_connector.py` (예: `vpc_connector.py`, `aws_connector.py`)
- 클래스명: `{Service}Connector` (예: `VpcConnector`, `AWSConnector`)
- 금지: 데이터 변환/가공, Manager/Service 호출
- 허용 import: 외부 SDK, spaceone.core.connector, config
- 규칙:
  - `BaseConnector` 또는 커스텀 베이스 클래스 상속
  - 메서드: `set_session()`, `list_{resource}()`, `get_{resource}()`
  - API 응답 그대로 반환 (변환 금지)
  - 인증/세션 관리 담당

---

## manager/
- 역할: 데이터 가공, CloudService/CloudServiceType 생성
- 파일명: `{resource}_manager.py` (예: `vpc_manager.py`, `war_manager.py`)
- 클래스명: `{Resource}Manager` (예: `VpcManager`, `WARManager`)
- 금지: 직접 API 호출 (Connector 통해야 함)
- 허용 import: connector, config, service, spaceone.core.manager, spaceone.inventory.plugin.collector.lib
- 규칙:
  - `BaseManager` 또는 `ResourceManager` 상속
  - 필수 메서드: `collect_resources()`, `create_cloud_service()`, `create_cloud_service_type()`
  - `make_cloud_service()`, `make_response()` 등 lib 함수 사용
  - Generator 패턴으로 yield 반환

---

## service/
- 역할: 비즈니스 로직, 데이터 추출/변환 로직
- 파일명: `{domain}_service.py` (예: `war_service.py`, `frameworks_service.py`)
- 클래스명: `{Domain}Service` (예: `WarService`, `FrameworksService`)
- 금지: 직접 API 호출, CloudService 생성
- 허용 import: data_format, config, 표준 라이브러리
- 규칙:
  - Manager에서 호출됨
  - 순수 데이터 처리 로직만 담당
  - Generator 패턴 사용 가능

---

## metadata/
- 역할: CloudServiceType 위젯/테이블 스키마 정의
- 파일명: `{resource}.yaml` 또는 `{resource}.yml`
- 금지: Python 로직
- 허용 import: 없음 (YAML 파일)
- 규칙:
  - Manager에서 `metadata_path`로 참조
  - 위젯, 테이블 레이아웃 정의

---

## metrics/
- 역할: 메트릭/네임스페이스 정의
- 파일명: `{metric_type}.yaml`
- 금지: Python 로직
- 허용 import: 없음 (YAML 파일)
- 규칙:
  - `namespace_*.yaml`: 네임스페이스 정의
  - 그 외: 메트릭 정의
