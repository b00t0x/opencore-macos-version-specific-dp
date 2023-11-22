# OpenCore: macOS version specific DeviceProperties
**より柔軟に設定できる kext を作成したので、このリポジトリはアーカイブされます。**

https://github.com/b00t0x/OSIEnhancer

## このリポジトリは何ですか？
[OpenCore](https://github.com/acidanthera/OpenCorePkg) の config.plist における `DeviceProperties` は、`MinKernel` / `MaxKernel` の概念を持たないため、macOS バージョンごとに異なる値を挿入することができません。

通常、このことは問題になりませんが、マルチブート環境において問題となるケースがあります。例えば、私の ThinkPad X280 は El Capitan (10.11) から最新の Sonoma (14) まで動作させることができますが、Kaby Lake のドライバを持たない El Capitan では Skylake の `device-id` を、Skylake のドライバを持たない macOS 13 以降では Kaby Lake の `device-id` を挿入する必要があります。

このリポジトリでは、`_OSI` を操作することで、macOS バージョンごとに異なる `DeviceProperties` を適用するサンプルを記載しています。

## kext patch
config.plist の `Kernel` / `Patch` セクションでは、`AppleACPIPlatform` にパッチを当てています。

`AppleACPIPlatform` では DSDT / SSDT で利用される `_OSI` メソッドにおける OS 名を設定しており、通常これは macOS バージョンによらず `Darwin` です。このパッチでは、El Capitan のカーネルバージョンを示す `Darw15` に置換しています。`Kernel `/ `Patch` セクションでは `MinKernel` / `MaxKernel` を設定可能なため、この変更を特定の macOS バージョン（ここでは El Capitan ）に限定することができます。

## SSDT-UHD620
`_DSM` メソッドの定義により、SSDT ファイルによって `DeviceProperties` を挿入することができます。ここでは、`Darw15` の場合に Skylake の `device-id`, `ig-platform-id` を設定し、それ以外では Kaby Lake のものを設定しています。

他の SSDT ファイルで `If (_OSI("Darwin"))` を使用している場合は、それらを `If (_OSI("Darwin") || _OSI("Darw15"))` に変更する必要があることに注意してください。

## _DSM to XDSM
少なくとも私の ThinkPad X280 の SSDT においては既に `_DSM` が定義済みだったため、定義済みの `_DSM` を `XDSM` にリネームして `_DSM` を再挿入可能にする必要がありました。

`_DSM` が DSDT と SSDT のどちらに定義されているかと、SSDT に定義されていた場合の `OemTableId` は PC によって異なることに注意してください。

## 謝辞
* Slice : AppleACPIPlatform patch の [アイデア](https://www.insanelymac.com/forum/topic/355374-how-to-make-ssdt-if-_osi-darwin-to-a-specific-version-of-macos/?do=findComment&comment=2800041) において
* RehabMan : [SSDT による DeviceProperties インジェクションガイド](https://www.tonymacx86.com/threads/guide-hackrnvmefamily-co-existence-with-ionvmefamily-using-class-code-spoof.210316/)
