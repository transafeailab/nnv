\ Model multiobj
\ LP format - for model browsing. Use MPS format to capture full model detail.
Minimize multi-objectives
  OBJ0: Priority=0 Weight=1 AbsTol=0 RelTol=0
   - C0 - 0.3333333333333333 C1
  OBJ1: Priority=0 Weight=1 AbsTol=0 RelTol=0
   C0 + C1
Subject To
 R0: C0 + C1 <= 2
 R1: C0 + 0.25 C1 <= 1
 R2: C0 - C1 <= 2
 R3: - 0.25 C0 - C1 <= 1
 R4: - C0 - C1 <= -1
 R5: - C0 + C1 <= 2
Bounds
End
