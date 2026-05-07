# Full Brightness

[English README](README.md)

Full Brightness는 여러 디스플레이를 쓰는 macOS 환경을 위한 유틸리티입니다. 연결된 디스플레이를 나열하고, 해상도와 HiDPI 정보를 보여주며, 밝기 제어가 가능한 디스플레이를 구분하고, 사용자가 정한 Full 밝기 기준으로 즉시 또는 새 디스플레이 연결 시 자동으로 밝기를 맞춥니다.

현재 GitHub 릴리즈: `2026.05.07.002`

## 요구 사항

- macOS 26 이상
- Apple Silicon 또는 Intel Mac
- 소스에서 빌드할 경우 Xcode 26 이상
- Apple 디스플레이 API 또는 DDC/CI를 통해 밝기 제어 경로를 노출하는 디스플레이

일부 모니터, 독, 케이블, KVM, DisplayLink 계열 어댑터는 밝기 제어를 막을 수 있습니다. Full Brightness는 이런 디스플레이도 목록에는 표시하지만, 무리하게 제어하지 않고 지원 안 함으로 표시합니다.

## 주요 기능

- **밝기 제어 가능 디스플레이 감지**  
  연결된 디스플레이를 나열하고 밝기 읽기/쓰기 가능 여부를 표시합니다.

- **사용자 지정 Full 밝기 기준**  
  Settings에서 내 환경의 Full 기준을 1%부터 100%까지 정할 수 있습니다.

- **한 번에 Full 밝기 적용**  
  메인 윈도우, 메뉴 막대, 제어 센터, 단축어, Siri, Spotlight에서 밝기 조정 가능한 모든 디스플레이를 Full 기준으로 맞춥니다.

- **연결 시 자동 Full 밝기**  
  자동 모드를 켜면 새로 연결된 밝기 조정 가능 디스플레이를 Full 기준으로 자동 설정합니다.

- **실시간 밝기 갱신**  
  macOS 디스플레이 제어나 하드웨어 키로 밝기가 바뀌어도 디스플레이 목록이 최신 상태로 갱신됩니다.

- **제어 센터 컨트롤**  
  macOS 제어 센터에 추가할 수 있는 두 개의 WidgetKit 컨트롤을 제공합니다:
  - `모니터 Full`: 지원되는 디스플레이를 즉시 Full 기준으로 설정합니다.
  - `연결 시 Full`: 새 디스플레이 연결 시 자동 Full 밝기 모드를 전환합니다.

- **메뉴 막대 유틸리티**  
  새로고침, 한 번에 Full 밝기 적용, 자동 모드, 디스플레이 상태, 앱 열기, 설정, 종료를 제공하는 간단한 메뉴 막대 뷰를 포함합니다.

- **네이티브 Settings와 로그인 시 실행**  
  표준 macOS Settings 창에서 Full 밝기 기준, 키보드 단축키, 로그인 시 실행을 설정합니다.

- **사용자 지정 키보드 단축키**  
  모니터 Full 적용과 디스플레이 목록 새로고침 단축키를 직접 입력할 수 있습니다. 중복되거나 표준 앱 명령과 겹치는 조합은 저장 전에 막습니다.

- **App Shortcuts 연동**  
  단축어, Siri, Spotlight에서 사용할 수 있는 App Intents 기반 단축어를 제공합니다:
  - `모니터 Full`
  - `자동 Full 켜기`
  - `자동 Full 끄기`

- **해상도와 HiDPI 정보**  
  macOS가 제공하는 경우 논리 해상도, HiDPI 배율, 실제 픽셀 해상도, 주사율을 보여줍니다.

- **영어와 한국어 지원**  
  시스템 또는 앱 언어 설정에 따라 영어와 한국어 UI를 지원합니다.

## 설치

GitHub 최신 릴리즈에서 `Full-Brightness-2026.05.07.002.zip`을 내려받아 압축을 풀고, `Full Brightness.app`을 `/Applications`로 옮깁니다.

현재 GitHub 빌드는 개발자 프리뷰 빌드이며 notarize되어 있지 않습니다. macOS가 실행을 차단하면 소스에서 직접 빌드하거나 본인의 Developer ID 인증서로 서명 및 notarize해야 합니다.

## 사용 방법

1. Full Brightness를 엽니다.
2. 디스플레이 목록과 지원 상태를 확인합니다.
3. 100%가 내 환경의 기준이 아니라면 Settings에서 Full 밝기 기준을 정합니다.
4. `연결된 모니터 Full`을 눌러 지원되는 모든 디스플레이를 해당 기준으로 맞춥니다.
5. 새로 연결되는 지원 디스플레이도 항상 Full 기준으로 맞추려면 `연결 시 자동 Full`을 켭니다.
6. 로그인 시 실행은 툴바 또는 메뉴 막대의 Settings에서 설정합니다.

## 제어 센터

앱을 설치하거나 실행한 뒤 macOS 제어 센터 사용자화 화면에서 Full Brightness를 검색하고 두 컨트롤을 추가합니다. 번들 식별자나 컨트롤 종류가 빌드 사이에 바뀐 경우 기존 컨트롤을 제거한 뒤 다시 추가해야 할 수 있습니다.

## App Shortcuts

단축어 앱 또는 Spotlight에서 Full Brightness를 검색합니다. 앱은 디스플레이를 Full 기준으로 맞추고 자동 모드를 켜거나 끄는 로컬라이즈된 App Intents 기반 단축어를 제공합니다.

## 디스플레이 지원 방식

Full Brightness는 다음 밝기 제어 경로를 시도합니다:

- 내장 디스플레이 및 LG UltraFine 같은 Apple 지원 디스플레이용 Apple DisplayServices 네이티브 밝기
- 일부 오래된 Apple 지원 경로의 macOS IOKit 디스플레이 밝기 파라미터
- 최신 Apple Silicon Mac에서 많은 외장 모니터에 쓰이는 Apple Silicon DCP/IOAVService DDC/CI
- 오래된 Intel 계열 디스플레이 경로의 IOFramebuffer I2C DDC/CI

지원되지 않는 디스플레이는 보통 디스플레이, 독, 케이블, 어댑터, 드라이버가 macOS에 쓰기 가능한 밝기 채널을 노출하지 않기 때문에 실패합니다.

## 빌드

```sh
./script/build_and_run.sh --verify
```

설치나 실행 없이 Release 빌드만 하려면:

```sh
./script/build_and_run.sh --release --build-only
```

이 스크립트는 `project.yml`에서 `FullBrightness.xcodeproj`를 다시 생성하고, Xcode로 앱을 빌드하며, macOS가 제어 센터 확장을 찾을 수 있도록 `/Applications/Full Brightness.app`에 설치할 수 있습니다.

## 릴리즈

공개 GitHub 릴리즈 태그는 날짜 기반 버전 `2026.05.07.002`을 사용합니다.

Apple 번들 버전 필드는 App Store 호환 숫자 형식을 사용합니다:

- `CFBundleShortVersionString`: `2026.5.7`
- `CFBundleVersion`: `20260507002`

## App Store 상태

Full Brightness는 현재 Mac App Store에 바로 제출하기에 안전한 구조가 아닙니다. 밝기 지원은 private macOS 디스플레이 API와 저수준 DDC/CI 경로에 의존합니다. Mac App Store 버전을 만들려면 공개 API와 호환되는 밝기 전략을 쓰거나 기능 범위를 줄여야 합니다.
