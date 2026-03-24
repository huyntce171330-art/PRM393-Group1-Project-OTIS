# OTIS Project - System Diagrams

> This file contains all Mermaid diagrams for the OTIS project.
> View this file on GitHub, VS Code (with Mermaid extension), or any Markdown viewer that supports Mermaid.

---

## 1. System Architecture Diagram

```mermaid
flowchart TB
    subgraph Presentation["<b style='color:#1565C0'>📱 Presentation Layer</b>"]
        Screens["<b>Screens</b><br/><font color='#1565C0'>46+ screens</font>"]
        Widgets["<b>Widgets</b><br/><font color='#1565C0'>Reusable components</font>"]
        BLoCs["<b>BLoCs</b><br/><font color='#1565C0'>11 modules × 3 files</font>"]
    end
    
    subgraph Domain["<b style='color:#2E7D32'>⚙️ Domain Layer</b>"]
        Entities["<b>Entities</b><br/><font color='#2E7D32'>18 entities</font>"]
        Repositories["<b>Repositories</b><br/><font color='#2E7D32'>Interfaces</font>"]
        UseCases["<b>UseCases</b><br/><font color='#2E7D32'>Business logic</font>"]
    end
    
    subgraph Data["<b style='color:#6A1B9A'>🗄️ Data Layer</b>"]
        Models["<b>Models</b><br/><font color='#6A1B9A'>DTOs / JSON</font>"]
        DataSources["<b>DataSources</b><br/><font color='#6A1B9A'>Local / Remote</font>"]
        ReposImpl["<b>Repositories</b><br/><font color='#6A1B9A'>Implementation</font>"]
    end
    
    subgraph Core["<b style='color:#EF6C00'>🔧 Core Layer</b>"]
        DI["<b>DI</b><br/><font color='#EF6C00'>GetIt</font>"]
        Network["<b>Network</b><br/><font color='#EF6C00'>Dio Client</font>"]
        Theme["<b>Theme</b><br/><font color='#EF6C00'>Colors, Fonts</font>"]
        Constants["<b>Constants</b><br/><font color='#EF6C00'>App config</font>"]
    end
    
    Presentation -->|"uses"| Domain
    Domain -->|"implemented by"| Data
    Data -->|"depends on"| Core
    Presentation -->|"uses"| Core
    
    style Presentation fill:#E3F2FD,stroke:#1565C0,color:#000
    style Domain fill:#E8F5E9,stroke:#2E7D32,color:#000
    style Data fill:#F3E5F5,stroke:#6A1B9A,color:#000
    style Core fill:#FFF3E0,stroke:#EF6C00,color:#000
```

---

## 2. Data Flow Diagram

```mermaid
sequenceDiagram
    participant User as "<b>👤 User</b>"
    participant Screen as "<b>📄 Screen</b>"
    participant BLoC as "<b>⚡ BLoC</b>"
    participant UseCase as "<b>🎯 UseCase</b>"
    participant Repository as "<b>📦 Repository</b>"
    participant DataSource as "<b>💾 DataSource</b>"
    participant Database as "<b>🗄️ SQLite</b>"
    
    User->>Screen: 1️⃣ User Interaction
    Screen->>BLoC: 2️⃣ Emit Event
    BLoC->>UseCase: 3️⃣ Execute UseCase
    UseCase->>Repository: 4️⃣ Call Repository
    
    Repository->>DataSource: 5️⃣ Fetch/Save Data
    DataSource->>Database: 6️⃣ SQLite Query
    Database-->>DataSource: 7️⃣ Return Results
    
    DataSource-->>Repository: 8️⃣ Return Model
    Repository-->>UseCase: 9️⃣ Return Entity
    UseCase-->>BLoC: 🔟 Return Result
    BLoC-->>Screen: 1️⃣1️⃣ Emit State
    Screen-->>User: 1️⃣2️⃣ UI Update
    
    style User fill:#E3F2FD,stroke:#1565C0,color:#000
    style Screen fill:#FFF8E1,stroke:#F9A825,color:#000
    style BLoC fill:#E8F5E9,stroke:#2E7D32,color:#000
    style UseCase fill:#F3E5F5,stroke:#6A1B9A,color:#000
    style Repository fill:#FBE9E7,stroke:#BF360C,color:#000
    style DataSource fill:#E0F7FA,stroke:#00838F,color:#000
    style Database fill:#F1F8E9,stroke:#558B2F,color:#000
```

---

## 3. Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    USER_ROLES ||--o{ USERS : "defines role"
        {
            role_id : int PK
            role_name : string
        }
    
    USERS ||--o{ CART_ITEMS : "adds items"
    USERS ||--o{ ORDERS : "places orders"
    USERS ||--o{ NOTIFICATIONS : "receives"
    USERS ||--o{ CHAT_ROOMS : "owns chat"
        {
            user_id : int PK
            phone : string UK
            password_hash : string
            full_name : string
            address : string
            shop_name : string
            avatar_url : string
            role_id : int FK
            status : string
            created_at : timestamp
        }
    
    BRANDS ||--o{ PRODUCTS : "manufactures"
        {
            brand_id : int PK
            name : string UK
            logo_url : string
        }
    
    TIRE_SPECS ||--o{ PRODUCTS : "specifies"
        {
            tire_spec_id : int PK
            width : int
            aspect_ratio : int
            rim_diameter : int
        }
    
    VEHICLE_MAKES ||--o{ PRODUCTS : "fits vehicle"
        {
            make_id : int PK
            name : string UK
            logo_url : string
        }
    
    PRODUCTS ||--o{ CART_ITEMS : "in cart"
    PRODUCTS ||--o{ ORDER_ITEMS : "ordered"
        {
            product_id : int PK
            sku : string UK
            name : string
            image_url : string
            brand_id : int FK
            make_id : int FK
            tire_spec_id : int FK
            price : decimal
            stock_quantity : int
            is_active : bool
            created_at : timestamp
        }
    
    ORDERS ||--o{ ORDER_ITEMS : "contains"
        {
            order_id : int PK
            code : string UK
            total_amount : decimal
            status : string
            shipping_address : string
            user_id : int FK
            created_at : timestamp
        }
    
    CHAT_ROOMS ||--o{ MESSAGES : "contains messages"
        {
            room_id : int PK
            user_id : int FK
            status : string
        }
    
    NOTIFICATIONS {
        notification_id : int PK
        title : string
        body : string
        is_read : bool
        user_id : int FK
        created_at : timestamp
    }
    
    ORDER_ITEMS {
        order_item_id : int PK
        order_id : int FK
        product_id : int FK
        quantity : int
        unit_price : decimal
    }
    
    CART_ITEMS {
        cart_item_id : int PK
        user_id : int FK
        product_id : int FK
        quantity : int
    }
    
    MESSAGES {
        message_id : int PK
        room_id : int FK
        sender_id : int FK
        content : string
        image_url : string
        is_read : bool
        created_at : timestamp
    }
    
    style USER_ROLES fill:#FFCDD2,stroke:#C62828,color:#000
    style USERS fill:#FFCDD2,stroke:#C62828,color:#000
    style BRANDS fill:#C8E6C9,stroke:#2E7D32,color:#000
    style TIRE_SPECS fill:#C8E6C9,stroke:#2E7D32,color:#000
    style VEHICLE_MAKES fill:#C8E6C9,stroke:#2E7D32,color:#000
    style PRODUCTS fill:#FFF9C4,stroke:#F9A825,color:#000
    style ORDERS fill:#BBDEFB,stroke:#1565C0,color:#000
    style CART_ITEMS fill:#E1BEE7,stroke:#7B1FA2,color:#000
    style ORDER_ITEMS fill:#BBDEFB,stroke:#1565C0,color:#000
    style CHAT_ROOMS fill:#B2DFDB,stroke:#00695C,color:#000
    style MESSAGES fill:#B2DFDB,stroke:#00695C,color:#000
    style NOTIFICATIONS fill:#D7CCC8,stroke:#5D4037,color:#000
```

---

## 4. BLoC State Management Pattern

```mermaid
flowchart LR
    subgraph Input["<b style='color:#1565C0'>📥 BLoC Input</b>"]
        Event["<b>Event</b><br/><font color='#1565C0'>User Actions</font>"]
    end
    
    subgraph Process["<b style='color:#6A1B9A'>⚙️ BLoC Core</b>"]
        Bloc["<b>BLoC</b><br/><font color='#6A1B9A'>Process Events<br/>→ Emit States</font>"]
    end
    
    subgraph Output["<b style='color:#2E7D32'>📤 BLoC Output</b>"]
        State["<b>State</b><br/><font color='#2E7D32'>UI State</font>"]
    end
    
    subgraph States["<b style='color:#EF6C00'>State Types</b>"]
        Initial["<b>Initial</b><br/><font color='#EF6C00'>🔘 Start</font>"]
        Loading["<b>Loading</b><br/><font color='#EF6C00'>⏳ Fetching...</font>"]
        Loaded["<b>Loaded</b><br/><font color='#EF6C00'>✅ With Data</font>"]
        Error["<b>Error</b><br/><font color='#EF6C00'>❌ Message</font>"]
    end
    
    Event -->|"trigger"| Bloc
    Bloc -->|"emit"| State
    State -->|"dispatch"| States
    
    Initial -->|"event arrives"| Loading
    Loading -->|"success"| Loaded
    Loading -->|"failure"| Error
    Error -->|"retry"| Loading
    Loaded -->|"new event"| Loading
    
    style Input fill:#E3F2FD,stroke:#1565C0,color:#000
    style Process fill:#F3E5F5,stroke:#6A1B9A,color:#000
    style Output fill:#E8F5E9,stroke:#2E7D32,color:#000
    style States fill:#FFF3E0,stroke:#EF6C00,color:#000
    style Initial fill:#ECEFF1,stroke:#607D8B,color:#000
    style Loading fill:#FFF9C4,stroke:#F9A825,color:#000
    style Loaded fill:#C8E6C9,stroke:#388E3C,color:#000
    style Error fill:#FFCDD2,stroke:#D32F2F,color:#000
```

---

## 5. Navigation Flow Diagram

```mermaid
flowchart TD
    subgraph Entry["<b style='color:#455A64'>🚪 Entry Point</b>"]
        Splash["<b>Splash Screen</b><br/><font color='#455A64'>Init App</font>"]
    end
    
    subgraph Auth["<b style='color:#1565C0'>🔐 Authentication</b>"]
        Login["<b>Login</b><br/><font color='#1565C0'>Phone + Password</font>"]
        Register["<b>Register</b><br/><font color='#1565C0'>New Account</font>"]
        Forgot["<b>Forgot Password</b><br/><font color='#1565C0'>Reset</font>"]
    end
    
    subgraph Customer["<b style='color:#2E7D32'>🛒 Customer Flow</b>"]
        Home["<b>Home</b><br/><font color='#2E7D32'>Products</font>"]
        Search["<b>Search</b><br/><font color='#2E7D32'>Find tires</font>"]
        ProductDetail["<b>Product Detail</b><br/><font color='#2E7D32'>View specs</font>"]
        Cart["<b>Cart</b><br/><font color='#2E7D32'>Shopping cart</font>"]
        Checkout["<b>Checkout</b><br/><font color='#2E7D32'>Pay</font>"]
        Orders["<b>Orders</b><br/><font color='#2E7D32'>History</font>"]
        OrderDetail["<b>Order Detail</b><br/><font color='#2E7D32'>Tracking</font>"]
        Profile["<b>Profile</b><br/><font color='#2E7D32'>Account</font>"]
        Chat["<b>Chat</b><br/><font color='#2E7D32'>Support</font>"]
        Notifications["<b>Notifications</b><br/><font color='#2E7D32'>Alerts</font>"]
        Map["<b>Map</b><br/><font color='#2E7D32'>Store locations</font>"]
    end
    
    subgraph Admin["<b style='color:#6A1B9A'>👨‍💼 Admin Flow</b>"]
        AdminHome["<b>Dashboard</b><br/><font color='#6A1B9A'>Stats</font>"]
        AdminProducts["<b>Products</b><br/><font color='#6A1B9A'>CRUD</font>"]
        AdminOrders["<b>Orders</b><br/><font color='#6A1B9A'>Manage</font>"]
        AdminUsers["<b>Users</b><br/><font color='#6A1B9A'>Accounts</font>"]
    end
    
    Splash -->|"start"| Login
    Login -->|"✅ success"| Home
    Login -->|"📝 no account"| Register
    Register -->|"✅"| Login
    Login -->|"🔑 forgot"| Forgot
    Forgot -->|"✅"| Login
    
    Home -->|"tap product"| ProductDetail
    Home -->|"🔍 search"| Search
    ProductDetail -->|"🛒 add to cart"| Cart
    Cart -->|"💳 checkout"| Checkout
    Checkout -->|"✅ place"| Orders
    Orders -->|"👁️ view"| OrderDetail
    
    Home -->|"📱 bottom nav"| Cart
    Home -->|"📱 bottom nav"| Orders
    Home -->|"📱 bottom nav"| Profile
    
    Profile -->|"💬 chat"| Chat
    Profile -->|"🔔 notifications"| Notifications
    Profile -->|"📍 map"| Map
    
    Login -->|"👨‍💼 admin role"| AdminHome
    AdminHome -->|"📦 products"| AdminProducts
    AdminHome -->|"📋 orders"| AdminOrders
    AdminHome -->|"👥 users"| AdminUsers
    
    style Entry fill:#ECEFF1,stroke:#455A64,color:#000
    style Auth fill:#E3F2FD,stroke:#1565C0,color:#000
    style Customer fill:#E8F5E9,stroke:#2E7D32,color:#000
    style Admin fill:#F3E5F5,stroke:#6A1B9A,color:#000
```

---

## 6. Order Status State Machine

```mermaid
stateDiagram-v2
    [*] --> Pending : "Create Order"
    
    Pending --> Confirmed : "Admin Confirm"
    Confirmed --> Processing : "Start Processing"
    Processing --> Shipping : "Ship Order"
    Shipping --> Delivered : "Delivered"
    Delivered --> [*] : "Complete"
    
    Pending --> Cancelled : "User Cancel"
    Confirmed --> Cancelled : "Admin Cancel"
    Processing --> Cancelled : "Admin Cancel"
    Cancelled --> [*] : "End"
    
    Pending --> Returned : "Return Request"
    Shipping --> Returned : "Refuse"
    Returned --> Refunded : "Refund"
    Refunded --> [*] : "End"
    
    note right of Pending : ⏳ Waiting<br/>for confirmation
    note right of Confirmed : ✅ Order<br/>confirmed
    note right of Processing : 🔧 Preparing<br/>your order
    note right of Shipping : 🚚 On the<br/>way
    note right of Delivered : 🎉 Order<br/>received
    note right of Cancelled : ❌ Order<br/>cancelled
    note right of Returned : 🔄 Return<br/>in progress
    note right of Refunded : 💰 Money<br/>refunded
    
    style Pending fill:#FFF9C4,stroke:#F9A825,color:#000
    style Confirmed fill:#C8E6C9,stroke:#2E7D32,color:#000
    style Processing fill:#BBDEFB,stroke:#1565C0,color:#000
    style Shipping fill:#B3E5FC,stroke:#0288D1,color:#000
    style Delivered fill:#C8E6C9,stroke:#388E3C,color:#000
    style Cancelled fill:#FFCDD2,stroke:#C62828,color:#000
    style Returned fill:#E1BEE7,stroke:#7B1FA2,color:#000
    style Refunded fill:#FFE0B2,stroke:#EF6C00,color:#000
```

---

## 7. Cart & Checkout Flow

```mermaid
flowchart TD
    subgraph Cart["<b style='color:#1565C0'>🛒 Shopping Cart</b>"]
        Browse["<b>Browse Products</b><br/><font color='#1565C0'>Home / Search</font>"]
        AddToCart["<b>Add to Cart</b><br/><font color='#1565C0'>Select quantity</font>"]
        UpdateQty["<b>Update Quantity</b><br/><font color='#1565C0'>+/- buttons</font>"]
        RemoveItem["<b>Remove Item</b><br/><font color='#1565C0'>Delete</font>"]
        ViewCart["<b>View Cart</b><br/><font color='#1565C0'>Review items</font>"]
    end
    
    subgraph Checkout["<b style='color:#EF6C00'>💳 Checkout Process</b>"]
        SelectAddress["<b>Select Address</b><br/><font color='#EF6C00'>Shipping address</font>"]
        SelectPayment["<b>Payment Method</b><br/><font color='#EF6C00'>COD / Online</font>"]
        ReviewOrder["<b>Review Order</b><br/><font color='#EF6C00'>Confirm details</font>"]
        PlaceOrder["<b>Place Order</b><br/><font color='#EF6C00'>Submit</font>"]
    end
    
    subgraph Payment["<b style='color:#2E7D32'>💰 Payment</b>"]
        PayCOD["<b>COD</b><br/><font color='#2E7D32'>Pay on delivery</font>"]
        PayOnline["<b>Online Payment</b><br/><font color='#2E7D32'>VNPay / MoMo</font>"]
        PaymentSuccess["<b>Payment Success</b><br/><font color='#2E7D32'>✅</font>"]
    end
    
    subgraph OrderPlaced["<b style='color:#6A1B9A'>📦 Order Created</b>"]
        OrderCreated["<b>Order Placed</b><br/><font color='#6A1B9A'>Order #XXX</font>"]
        OrderConfirmed["<b>Confirmed</b><br/><font color='#6A1B9A'>Processing</font>"]
        OrderShipped["<b>Shipped</b><br/><font color='#6A1B9A'>In transit</font>"]
        OrderDelivered["<b>Delivered</b><br/><font color='#6A1B9A'>Received</font>"]
    end
    
    Browse --> AddToCart
    AddToCart --> ViewCart
    UpdateQty --> ViewCart
    RemoveItem --> ViewCart
    ViewCart -->|"proceed"| Checkout
    
    Checkout --> SelectAddress
    SelectAddress --> SelectPayment
    SelectPayment --> ReviewOrder
    ReviewOrder --> PlaceOrder
    
    PlaceOrder --> PayCOD
    PlaceOrder --> PayOnline
    
    PayCOD --> PaymentSuccess
    PayOnline --> PaymentSuccess
    
    PaymentSuccess --> OrderCreated
    OrderCreated --> OrderConfirmed
    OrderConfirmed --> OrderShipped
    OrderShipped --> OrderDelivered
    
    style Cart fill:#E3F2FD,stroke:#1565C0,color:#000
    style Checkout fill:#FFF3E0,stroke:#EF6C00,color:#000
    style Payment fill:#E8F5E9,stroke:#2E7D32,color:#000
    style OrderPlaced fill:#F3E5F5,stroke:#6A1B9A,color:#000
```

---

## 8. Real-time Chat Flow (Socket.IO)

```mermaid
sequenceDiagram
    participant Customer as "<b>👤 Customer</b>"
    participant App as "<b>📱 OTIS App</b>"
    participant Socket as "<b>🔌 Socket.IO</b>"
    participant Server as "<b>🖥️ Server</b>"
    participant Admin as "<b>👨‍💼 Admin</b>"
    
    Customer->>App: 1️⃣ Open Chat
    App->>Socket: 2️⃣ Connect
    Socket->>Server: 3️⃣ Create/Get Room
    Server-->>Socket: 4️⃣ Room ID
    Socket-->>App: 5️⃣ Join Success
    
    Customer->>App: 6️⃣ Type Message
    App->>Socket: 7️⃣ Emit 'message'
    Socket->>Server: 8️⃣ Send
    Server->>Server: 9️⃣ Save to DB
    
    Server-->>Socket: 🔟 Broadcast
    Socket-->>App: 1️⃣1️⃣ Receive
    App-->>Customer: 1️⃣2️⃣ Display
    Socket-->>Admin: 1️⃣3️⃣ Notify Admin
    
    Admin->>Socket: 1️⃣4️⃣ Reply
    Socket-->>Server: 1️⃣5️⃣ Send
    Server-->>Socket: 1️⃣6️⃣ Broadcast
    Socket-->>App: 1️⃣7️⃣ Receive
    App-->>Customer: 1️⃣8️⃣ Show Reply
    
    Customer->>App: 1️⃣9️⃣ Close Chat
    App->>Socket: 2️⃣0️⃣ Disconnect
    
    style Customer fill:#E3F2FD,stroke:#1565C0,color:#000
    style App fill:#E8F5E9,stroke:#2E7D32,color:#000
    style Socket fill:#FFF9C4,stroke:#F9A825,color:#000
    style Server fill:#F3E5F5,stroke:#6A1B9A,color:#000
    style Admin fill:#FFE0B2,stroke:#EF6C00,color:#000
```

---

## 9. Notification Flow

```mermaid
flowchart LR
    subgraph Trigger["<b style='color:#C62828'>🔔 Triggers</b>"]
        NewOrder["<b>New Order</b><br/><font color='#C62828'>Customer places order</font>"]
        OrderUpdate["<b>Order Update</b><br/><font color='#C62828'>Status change</font>"]
        ChatMsg["<b>New Chat</b><br/><font color='#C62828'>Admin reply</font>"]
        Promotions["<b>Promotion</b><br/><font color='#C62828'>Deals / Offers</font>"]
    end
    
    subgraph Send["<b style='color:#1565C0'>📤 Send</b>"]
        CreateNoti["<b>Create</b><br/><font color='#1565C0'>Build notification</font>"]
        StoreNoti["<b>Store</b><br/><font color='#1565C0'>Save to DB</font>"]
        PushNoti["<b>Push</b><br/><font color='#1565C0'>FCM / Local</font>"]
    end
    
    subgraph Receive["<b style='color:#2E7D32'>📥 Receive</b>"]
        DeviceNoti["<b>Device</b><br/><font color='#2E7D32'>Show banner</font>"]
        AppBadge["<b>Badge</b><br/><font color='#2E7D32'>Unread count</font>"]
        NotiList["<b>Notification List</b><br/><font color='#2E7D32'>View all</font>"]
        NotiDetail["<b>Detail</b><br/><font color='#2E7D32'>Tap to view</font>"]
    end
    
    NewOrder --> CreateNoti
    OrderUpdate --> CreateNoti
    ChatMsg --> CreateNoti
    Promotions --> CreateNoti
    
    CreateNoti --> StoreNoti
    StoreNoti --> PushNoti
    
    PushNoti --> DeviceNoti
    PushNoti --> AppBadge
    DeviceNoti --> NotiList
    AppBadge --> NotiList
    NotiList --> NotiDetail
    
    style Trigger fill:#FFCDD2,stroke:#C62828,color:#000
    style Send fill:#E3F2FD,stroke:#1565C0,color:#000
    style Receive fill:#C8E6C9,stroke:#2E7D32,color:#000
```

---

## 10. Technology Stack Diagram

```mermaid
flowchart TB
    subgraph Frontend["<b style='color:#1565C0'>📱 Frontend - Flutter</b>"]
        UI["<b>UI Layer</b><br/>Screens + Widgets"]
        State["<b>State</b><br/>BLoC Pattern"]
        Nav["<b>Navigation</b><br/>GoRouter"]
    end
    
    subgraph Backend["<b style='color:#2E7D32'>⚙️ Backend - Node.js</b>"]
        API["<b>REST API</b><br/>Express.js"]
        Socket["<b>Socket.IO</b><br/>Real-time"]
        DB["<b>Database</b><br/>SQLite / MySQL"]
    end
    
    subgraph Services["<b style='color:#EF6C00'>🔧 Services</b>"]
        Auth["<b>Auth</b><br/>JWT / Phone"]
        Noti["<b>Notifications</b><br/>Push / Local"]
        Storage["<b>Storage</b><br/>Cloud / Local"]
    end
    
    UI --> State
    State --> Nav
    Nav --> API
    Nav --> Socket
    
    API --> DB
    API --> Auth
    API --> Noti
    API --> Storage
    
    style Frontend fill:#E3F2FD,stroke:#1565C0,color:#000
    style Backend fill:#E8F5E9,stroke:#2E7D32,color:#000
    style Services fill:#FFF3E0,stroke:#EF6C00,color:#000
    style UI fill:#BBDEFB,stroke:#1976D2,color:#000
    style State fill:#DCEDC8,stroke:#689F38,color:#000
    style Nav fill:#B3E5FC,stroke:#03A9F4,color:#000
    style API fill:#D7CCC8,stroke:#6D4C41,color:#000
    style Socket fill:#FFE082,stroke:#FFA000,color:#000
    style DB fill:#FFCCBC,stroke:#D84315,color:#000
    style Auth fill:#E1BEE7,stroke:#7B1FA2,color:#000
    style Noti fill:#B2EBF2,stroke:#00838F,color:#000
    style Storage fill:#CFD8DC,stroke:#455A64,color:#000
```

---

## 11. Project Directory Structure

```mermaid
graph TD
    subgraph lib["<b>lib/</b>"]
        subgraph core["<b>core/</b>"]
            C1["<b>constants/</b><br/>App constants"]
            C2["<b>error/</b><br/>Exceptions"]
            C3["<b>injections/</b><br/>GetIt setup"]
            C4["<b>network/</b><br/>Dio config"]
            C5["<b>theme/</b><br/>Colors, Typography"]
            C6["<b>utils/</b><br/>Helpers"]
        end
        
        subgraph data["<b>data/</b>"]
            D1["<b>datasources/</b><br/>Local + Remote"]
            D2["<b>models/</b><br/>Data models"]
            D3["<b>repositories/</b><br/>Implementations"]
        end
        
        subgraph domain["<b>domain/</b>"]
            DO1["<b>entities/</b><br/>18 entities"]
            DO2["<b>repositories/</b><br/>Interfaces"]
            DO3["<b>usecases/</b><br/>Business logic"]
        end
        
        subgraph presentation["<b>presentation/</b>"]
            P1["<b>bloc/</b><br/>33 BLoC files"]
            P2["<b>screens/</b><br/>46+ screens"]
            P3["<b>widgets/</b><br/>Reusable widgets"]
        end
        
        App["<b>app.dart</b><br/>App config"]
        Main["<b>main.dart</b><br/>Entry point"]
    end
    
    style lib fill:#ECEFF1,stroke:#455A64,color:#000
    style core fill:#E3F2FD,stroke:#1565C0,color:#000
    style data fill:#E8F5E9,stroke:#2E7D32,color:#000
    style domain fill:#F3E5F5,stroke:#6A1B9A,color:#000
    style presentation fill:#FFF3E0,stroke:#EF6C00,color:#000
    style App fill:#FFECB3,stroke:#FFA000,color:#000
    style Main fill:#FFECB3,stroke:#FFA000,color:#000
    style C1 fill:#BBDEFB,stroke:#1565C0,color:#000
    style C2 fill:#FFCDD2,stroke:#C62828,color:#000
    style C3 fill:#C8E6C9,stroke:#2E7D32,color:#000
    style C4 fill:#B3E5FC,stroke:#0288D1,color:#000
    style C5 fill:#E1BEE7,stroke:#7B1FA2,color:#000
    style C6 fill:#FFE0B2,stroke:#EF6C00,color:#000
    style D1 fill:#B2DFDB,stroke:#00695C,color:#000
    style D2 fill:#D7CCC8,stroke:#5D4037,color:#000
    style D3 fill:#CFD8DC,stroke:#455A64,color:#000
    style DO1 fill:#F8BBD0,stroke:#E91E63,color:#000
    style DO2 fill:#D1C4E9,stroke:#673AB7,color:#000
    style DO3 fill:#B39DDB,stroke:#512DA8,color:#000
    style P1 fill:#80DEEA,stroke:#0097A7,color:#000
    style P2 fill:#A5D6A7,stroke:#388E3C,color:#000
    style P3 fill:#FFF59D,stroke:#F9A825,color:#000
```

---

## 12. Color Palette Reference

```mermaid
flowchart LR
    subgraph Primary["<b>Primary Colors</b>"]
        P1["🔵 #1565C0<br/>Blue<br/>Main actions"]
        P2["🟢 #2E7D32<br/>Green<br/>Success"]
        P3["🟣 #6A1B9A<br/>Purple<br/>Data layer"]
    end
    
    subgraph Accent["<b>Accent Colors</b>"]
        A1["🟠 #EF6C00<br/>Orange<br/>CTAs"]
        A2["🔴 #C62828<br/>Red<br/>Errors"]
        A3["🟡 #F9A825<br/>Amber<br/>Warnings"]
    end
    
    subgraph Neutral["<b>Neutral Colors</b>"]
        N1["⚪ #FFFFFF<br/>White<br/>Background"]
        N2["⬜ #F5F5F5<br/>Grey<br/>Surface"]
        N3["🪨 #455A64<br/>Blue Grey<br/>Text"]
    end
    
    style Primary fill:#E3F2FD,stroke:#1565C0,color:#000
    style Accent fill:#FFF3E0,stroke:#EF6C00,color:#000
    style Neutral fill:#ECEFF1,stroke:#455A64,color:#000
    style P1 fill:#BBDEFB,stroke:#1565C0,color:#000
    style P2 fill:#C8E6C9,stroke:#2E7D32,color:#000
    style P3 fill:#E1BEE7,stroke:#6A1B9A,color:#000
    style A1 fill:#FFE0B2,stroke:#EF6C00,color:#000
    style A2 fill:#FFCDD2,stroke:#C62828,color:#000
    style A3 fill:#FFF9C4,stroke:#F9A825,color:#000
    style N1 fill:#FFFFFF,stroke:#BDBDBD,color:#000
    style N2 fill:#F5F5F5,stroke:#BDBDBD,color:#000
    style N3 fill:#ECEFF1,stroke:#455A64,color:#000
```

---

**Report Generated:** March 2026  
**Team:** PRM393 Group 1 - OTIS Project
