import matplotlib.pyplot as plt

# 예시 데이터
years = [2019, 2020, 2021, 2022, 2023, 2024, 2025]  # x축: 연도
py = [10, 15, 20, 25, 30, 1, 23.37]           # y축: 사용량 (%)
js = [5, 7, 12, 18, 22, 1, 3.42]
ts = [8, 12, 18, 20, 25, 3, ]
ja = [2, 5, 7, 10, 15, 1, 8.54]

# 그래프 생성
plt.figure(figsize=(10, 6))

plt.plot(years, py, marker='o', label='Python')
plt.plot(years, js, marker='s', label='JavaScript')
plt.plot(years, ts, marker='^', label='TypeScript')
plt.plot(years, ja, marker='d', label='Java')

# 제목과 축 레이블
plt.title('Popularity of Programming Languages')
plt.xlabel('Year')
plt.ylabel('Rating (%)')

# 범례 표시
plt.legend()

# 격자 표시
# plt.grid(True)

# 그래프 출력
plt.tight_layout()
plt.show()

