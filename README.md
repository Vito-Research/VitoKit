# VitoKit

![Twitter post - 8.png](https://res.craft.do/user/full/23a03a79-af5e-1af9-b4ff-27170389b6b1/doc/AB3125ED-4677-462B-B685-7579F290E38A/07815B4B-95A1-4CA6-91E7-F8EC17B9F535_2/If1dhMo7DxNcxeSQOlh06ZSAVZAyFSexxVGsRVqnnhgz/Twitter%20post%20-%208.png)

## 😀 Welcome to VitoKit...

### A framework that enhances HealthKit and the Fitbit API for iOS

### ✅ Features

- Wonderfully crafted animations
- Speedy setup and computations
- More efficient and powerful way to build health apps

### 🚀 Getting Started

```swift
let package = Package(
    dependencies: [
        .package(url: "git@github.com:Vito-Research/VitoKit.git")
    ]
)

import VitoKit

```

#### Request Permission

Depending on which category of health data you would like to query, within toggle data, add your requested category...

> Vitals - heart rate, respiration rate, heart rate variability

> Activity - steps, stand hours, workouts

> Mobility - double support time, walking asymmetry, step length

```swift
DataTypesListView(toggleData: [.Vitals], title: "Health Data", caption: "Why we need this data...")
```

#### Data Querying

VitoKit has various ways to query and process health data...

State Machine

A level based algorithm that detects outliers

```swift
for type in HKQuantityTypeIdentifier.Activity {
                            
                            vito.outliers(for: type, unit: type.unit, with: Date().addingTimeInterval(.month * 4), to: Date(), filterToActivity: .active)
                        }
```

Machine Learning

Random Forest Classifier

```swift

  do {
                        let ml = ML()
                        let correlation = try ml.classifier(vito.healthData)
                        } catch {
                            
                        }
```

Deep Learning

TBD


