tt = []
with open('/Users/zhangbo/imei.rs', 'r') as f:
    for line in f.readlines():
        tmp = re.sub(r'\n', '', line)
        if len(tmp)==15:
            tt.append(tmp)

with open('/Users/zhangbo/imei_clean.txt', 'a') as f:
    for item in tt:
        f.write(item+'\n')
