cd C:\Users\X1\Downloads\apache-jmeter-5.1.1\apache-jmeter-5.1.1\bin\numbers2
for /l %%x in (31, 1, 400) do (
echo %%x 
magick convert %%x.png %%x.ico
magick %%x.ico -resize 32x32 %%x.ico
)