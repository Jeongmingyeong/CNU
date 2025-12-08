import matplotlib.pyplot as plt
import numpy as np

# 연도 (2014~2024)
years = np.arange(2013, 2025)

# 예시 데이터: 각 연도별 4가지 방법론의 개수
data = {
    "TOTAL":                            [2, 1, 2, 2, 1, 2, 1, 4, 2, 4, 3, 3],
    "Static w/o AI":                    [2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2],
    "Dynamic":                          [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    "Hybrid w/o AI":                    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    "AI-based":                         [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    "Hybrid(Static, Dynamic)":          [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    "Hybrid(Static, AI)":               [0, 0, 0, 0, 0, 1, 0, 2, 1, 2, 3, 1]
}

# 그래프 생성
plt.figure(figsize=(12, 6))

# 각 방법론별 선 그리기
for method, counts in data.items():
    plt.plot(years, counts, marker='o', label=method)

# 레이블과 제목
plt.xlabel("Year")
plt.ylabel("Number of papers/tools")
# plt.title("Figure X: Number of Python type analysis papers and tools developed per year (2013–2024) by methodology. This line chart illustrates the annual trends in the development of research and tools across different type checking approaches, including static, dynamic, hybrid, and AI-based methods.")

# x축 눈금과 레이블
xticks = years
xticklabels = ["~2013"] + list(years[1:])  # 첫 값만 "~2013"
plt.xticks(xticks, xticklabels)

# y축 정수로 설정
plt.yticks(range(0, max([max(v) for v in data.values()]) + 1))

# 범례
plt.legend()

# 레이아웃 조정
plt.tight_layout()

# PDF로 저장
plt.savefig("rq3.pdf", format="pdf")

