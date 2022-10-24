import itertools

l = ["ص", "ق", "د","ي"]
smallest = 3


out='['
for i in range(smallest,len(l)+1):
  for subset in itertools.permutations(l, i):
    # print(subset)
    w='"'
    for letter in subset:
      w+=letter
    w+='"'
    out+=w
    out+= ','


out=out[0:-1]
out+=']'
print(out)
