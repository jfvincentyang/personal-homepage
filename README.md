# Personal Homepage

静态个人主页，用于展示物业管理、综合办公室事务执行、项目推进、风险控制和数字化工具落地能力。

## 文件结构

```text
index.html
styles.css
script.js
assets/
tools/
```

## 本地预览

直接双击打开：

```text
index.html
```

## 图片优化

网页实际加载的是 `assets/*.jpg` 压缩图。原始 PNG 图片仅保留在本地，不提交到 GitHub。

如需重新压缩图片，可在 Windows PowerShell 中运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\compress-images.ps1
```

## Netlify

这是纯静态站点，无需构建命令。Netlify 发布目录为项目根目录。

