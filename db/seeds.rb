# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
    name:"First Admin Creator", 
    username:"admin", 
    password:"godmode01", 
    role:1, 
    email:"admin@admin.com", 
    birthdate:"9/7/1998"
    )

User.create(
    company:false,
    name:"john barbosa",
    username:"tester",
    password:"godmode01",
    birthdate:"9/7/1998",
    gender:0,
    email:"john@test.com"
    )

t = Token.create(
    secret:"c7943442979a4d41a493684bb172ae57", 
    expire_at:"2018-04-20", 
    user_id:2
    )
t.update_attribute(:secret, "c7943442979a4d41a493684bb172ae57")

t = Token.create(
    secret:"1176d87103eb423fabb3c67ed952749d", 
    expire_at:"2018-04-20", 
    user_id: 1
    )
t.update_attribute(:secret, "1176d87103eb423fabb3c67ed952749d")

Origin.create(
    country:"colombia", 
    state:"barranquilla", 
    city:"atlantico", 
    postal_code:8000, 
    address:"43 con frutera y patillazo", 
    description:"El Timbre no sirve toque duro",
    user_id: 2
    )

Origin.create(
    country:"colombia", 
    state:"barranquilla", 
    city:"atlantico", 
    postal_code:8000, 
    address:"calle 90", 
    description:"Nogales", 
    user_id:1
    )

Product.create(
    name:"arroz", 
    description:"arroz de coco por sacos", 
    category:0, 
    shipping_description:"no mando pa' australia", 
    origin_id:1, 
    user_id:2, 
    stock:3, 
    price:19999.0, 
    is_used:false, 
    is_auction:true
    )

Product.create(
    name:"arroz wolo", 
    description:"arroz de coco por sacos", 
    category:0, 
    shipping_description:"solo envio india", 
    origin_id:1, 
    user_id:2, 
    stock:30, 
    price:200.0, 
    is_used:false, 
    is_auction:false
    )

Product.create(
    name:"yuca", 
    description:"deliciosa yuca colombiana", 
    category:0, 
    shipping_description:"solo colombia joven", 
    origin_id:2, 
    user_id:2, 
    stock:10, 
    price:20000.0, 
    is_used:false, 
    is_auction:true
    )

Product.create(
    name:"asus", 
    description:"portatil asus", 
    category:3, 
    shipping_description:"solo colombia", 
    origin_id:2, 
    user_id:2, 
    stock:2, 
    price:2500000.0, 
    is_used:false, 
    is_auction:false
    )