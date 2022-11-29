puts "Hello World"
puts "Hello World"
puts ""

y = "World"
num = 2022
 
printf("Hello %s %d\n", y, num)
puts ""

x = 2
while x <= 10 do
    if x % 2 == 0 
        puts "Hello World"
        x += 1
    else
        puts "Goodbye!"
        x += 1
    end
end
puts ""

def say_hello(i)
    puts "Hello!"
    puts "i is #{i}"
end

def say_goodbye(i)
    puts "i is now #{i}"
    puts "Goodbye!"
end

i = 1
say_hello(i)
i += 1
say_goodbye(i)
