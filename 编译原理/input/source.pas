begin
  integer k;
  intger function F(n);
    begin
      integer n;
      if n<=0 then F:=1
      else F:=n*F(n-1)
    end
  integer m;
  read(m);
  k:=F(m);
  write(k);
end
