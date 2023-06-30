import random

# 영단어와 뜻이 튜플로 저장
words = [("aggressively", "적극적으로"), ("certificate", "증서"), ("collate", "대조하다" ), ("dedicated", "헌신적인"),
         ("desirous", "갈망하는"), ("drape", "천으로 덮다"), ("durable", "내구성있는"), ("eligible", "자격이 되는"),
         ("emphasis", "강조"), ("engraved", "새겨진"), ("escort", "수행하다"), ("expedite", "신속화하다"),
         ("factions", "당파들"), ("fascinated", "매혹된"), ("fiscal", "회계의"), ("hesitantly", "우물쭈물"),
         ("imperative", "중요한"), ("itinerary", "일정"), ("lawsuit", "소송"), ("overdue", "연체된")]
# 결과 저장 리스트
result = []

for word in words:
    # 랜덤값 생성
    i = random.choice([0, 1])
    result.append(word[i])

random.shuffle(result)

for value in result:
    print(value)




