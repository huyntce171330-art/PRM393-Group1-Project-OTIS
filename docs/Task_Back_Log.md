**![]()

---

### MODULE: PRODUCT MANAGEMENT (HOME SCREEN)

#### 1. UC-08: View List Products (Xem danh sách sản phẩm)

* Actor: Guest, Customer.
* Description: Hiển thị danh sách sản phẩm trên màn hình trang chủ để người dùng duyệt xem. Hỗ trợ phân trang (pagination) hoặc tải thêm (infinite scroll).
* Pre-conditions:

  * Người dùng mở ứng dụng và đang ở màn hình Home.
  * Kết nối mạng ổn định.
* Post-conditions:
* Danh sách sản phẩm được hiển thị kèm hình ảnh, tên và giá.
* Normal Flow (Luồng chính):
* User mở ứng dụng hoặc điều hướng về tab Home.
* Hệ thống gửi request lấy danh sách sản phẩm (mặc định trang 1, ví dụ 10 sản phẩm mới nhất).
* Hệ thống hiển thị skeleton loading (khung xương chờ tải).
* Hệ thống tải dữ liệu thành công và hiển thị danh sách sản phẩm (Ảnh, Tên, Giá, Icon giỏ hàng).
* User cuộn xuống cuối danh sách.
* Hệ thống tự động tải tiếp trang 2 (Lazy loading).
* Exception Flows (Luồng ngoại lệ):
* E1: Mất kết nối mạng (Network Error)
* Hệ thống hiển thị màn hình lỗi: "Không có kết nối Internet".
* Hiển thị nút "Thử lại" (Retry).
* User nhấn "Thử lại", hệ thống thực hiện lại bước 2 của luồng chính.
* E2: Server lỗi hoặc timeout
* Hệ thống thông báo: "Có lỗi xảy ra, vui lòng thử lại sau".
* E3: Danh sách rỗng (Empty State)
* Nếu hệ thống chưa có sản phẩm nào, hiển thị thông báo/hình ảnh: "Hiện chưa có sản phẩm nào".
* Business Rules:
* Sản phẩm hiển thị phải có trạng thái Active (không hiển thị sản phẩm đã bị Admin ẩn).
* Giá hiển thị phải là giá hiện tại (đã giảm giá nếu có).
* Sắp xếp mặc định theo ngày tạo mới nhất (Newest first).

---

#### 2. UC-10: Search Product (Tìm kiếm sản phẩm)

* Actor: Guest, Customer.
* Description: Cho phép người dùng tìm sản phẩm theo tên hoặc từ khóa liên quan.
* Pre-conditions:

  * Người dùng đang ở màn hình Home.
* Post-conditions:
* Hiển thị danh sách sản phẩm khớp với từ khóa tìm kiếm.
* Normal Flow (Luồng chính):
* User nhấn vào thanh tìm kiếm (Search Bar) trên Home Screen.
* User nhập từ khóa (ví dụ: "iPhone").
* User nhấn nút "Search" trên bàn phím ảo hoặc icon kính lúp.
* Hệ thống validate từ khóa (độ dài > 0).
* Hệ thống gửi request tìm kiếm tới Server.
* Hệ thống trả về danh sách kết quả phù hợp.
* User xem danh sách kết quả.
* Alternative Flows (Luồng thay thế):
* A1: Gợi ý tìm kiếm (Search Suggestion) - Optional
* Khi User đang gõ (typing), hệ thống tự động gợi ý các sản phẩm có tên bắt đầu bằng ký tự đang gõ.
* Exception Flows (Luồng ngoại lệ):
* E1: Không tìm thấy kết quả (No Results)
* Hệ thống hiển thị: "Không tìm thấy sản phẩm nào phù hợp với từ khóa '[Keyword]'".
* Gợi ý User thử từ khóa khác.
* E2: Từ khóa chứa ký tự đặc biệt không hợp lệ
* Hệ thống tự động loại bỏ ký tự đặc biệt hoặc thông báo lỗi (tùy logic backend).
* Business Rules:
* Tìm kiếm không phân biệt chữ hoa/chữ thường (Case-insensitive).
* Tìm kiếm theo kiểu "Contains" (chứa từ khóa) chứ không cần chính xác tuyệt đối.

---

#### 3. UC-11: Filter Product (Lọc sản phẩm)

* Actor: Guest, Customer.
* Description: Giúp người dùng thu hẹp phạm vi tìm kiếm theo danh mục hoặc khoảng giá.
* Pre-conditions:

  * Đang hiển thị danh sách sản phẩm (tại Home hoặc màn hình Search Result).
* Post-conditions:
* Danh sách sản phẩm được cập nhật theo điều kiện lọc.
* Normal Flow (Luồng chính):
* User nhấn vào biểu tượng/nút "Filter" (Lọc).
* Hệ thống hiển thị Bottom Sheet hoặc Dialog các tiêu chí lọc:
* Khoảng giá (Price Range: Min - Max).
* User chọn danh mục (VD: Laptop) và nhập khoảng giá (VD: 10tr - 20tr).
* User nhấn nút "Apply" (Áp dụng).
* Hệ thống gửi request với các tham số filter.
* Hệ thống cập nhật lại danh sách sản phẩm trên màn hình.
* Exception Flows (Luồng ngoại lệ):
* E1: Nhập khoảng giá sai
* User nhập Giá Min > Giá Max.
* Hệ thống báo lỗi ngay trên Dialog: "Giá tối thiểu không được lớn hơn giá tối đa".
* Disable (vô hiệu hóa) nút "Apply" cho đến khi nhập đúng.
* E2: Lọc không ra kết quả
* Hệ thống hiển thị Empty State: "Không có sản phẩm nào thỏa mãn điều kiện lọc".
* Hiển thị nút "Xóa bộ lọc" (Clear Filter) để quay lại danh sách gốc.
* Business Rules:
* Bộ lọc có thể áp dụng đồng thời (vừa lọc theo lọc theo Price).
* Nếu không chọn Category, mặc định là "All".

**

#### . UC-09: View Product Details (Xem chi tiết sản phẩm)

* **Actor:** Guest, Customer.
* **Description:** Hiển thị toàn bộ thông tin chi tiết của một sản phẩm cụ thể, bao gồm hình ảnh, giá bán, thông số kỹ thuật, đánh giá và các tùy chọn mua hàng.
* **Pre-conditions:**
  * Người dùng đã chọn một sản phẩm từ danh sách (Home, Search Result, hoặc Cart).
  * Có `productId` hợp lệ được truyền sang.
* **Post-conditions:**
  * Người dùng nhìn thấy đầy đủ thông tin sản phẩm.
  * Các nút hành động (Add to Cart, Buy Now) ở trạng thái sẵn sàng (nếu còn hàng).

**Normal Flow (Luồng chính):**

1. User nhấn vào một thẻ sản phẩm (Product Card).
2. Hệ thống chuyển hướng sang màn hình Product Detail.
3. Hệ thống hiển thị **Skeleton Loading** cho các khối nội dung (Image, Info, Specs, Reviews).
4. Hệ thống gọi API lấy chi tiết sản phẩm dựa trên `productId`.
5. Hệ thống tải dữ liệu thành công và hiển thị:
   * **Header Bar:** Nút Back, Tiêu đề, và Icon Giỏ hàng (kèm badge số lượng).
   * **Image Gallery:** Carousel ảnh sản phẩm (cho phép vuốt ngang).
   * **Basic Info:** Tên sản phẩm, Badge "In Stock", Logo thương hiệu, Giá bán (Sale & Gốc), Ghi chú VAT.
   * **Specs Grid:** Lưới thông số kỹ thuật (Width, Profile, Rim, Speed) với icon tương ứng.
   * **Services:** Thông tin bảo hành và vận chuyển.
   * **Reviews:** Tóm tắt đánh giá (Rating trung bình) và list 2-3 review mới nhất.
   * **Sticky Footer:** Thanh tác vụ cố định chứa nút "Add to Cart" và "Buy Now".
6. User vuốt xem ảnh hoặc cuộn xuống xem thông tin.

**Alternative Flows (Luồng thay thế):**

* **A1: Xem tất cả đánh giá (View All Reviews)**
  * User nhấn nút "See All" ở mục Reviews.
  * Hệ thống điều hướng sang màn hình danh sách đánh giá chi tiết.
* **A2: Zoom ảnh**
  * User nhấn vào ảnh trong Carousel.
  * Hệ thống mở trình xem ảnh Fullscreen (Photo View).

**Exception Flows (Luồng ngoại lệ):**

* **E1: Sản phẩm không tồn tại hoặc bị ẩn (404/Inactive)**
  * Hệ thống hiển thị thông báo: "Sản phẩm này không còn tồn tại hoặc đã ngừng kinh doanh".
  * Tự động điều hướng quay lại trang trước sau 2 giây hoặc hiển thị nút "Về trang chủ".
* **E2: Load thất bại (Network Error)**
  * Hiển thị màn hình lỗi kết nối + Nút Retry.
* **E3: Hết hàng (Out of Stock)**
  * Thay đổi trạng thái Badge "In Stock" (Xanh) thành "Out of Stock" (Xám/Đỏ).
  * **Disable** (làm mờ) nút "Add to Cart" và "Buy Now".
  * Hoặc thay bằng nút "Notify Me" (Nhận thông báo khi có hàng).

**Business Rules (Quy tắc nghiệp vụ - Quan trọng cho Dev):**

1. **Price Display:**
   * Nếu `sale_price < original_price`: Hiển thị `sale_price` màu đỏ/nổi bật, `original_price` gạch ngang màu xám.
   * Nếu không giảm giá: Chỉ hiện `original_price` màu nổi bật.
2. **Specs Rendering:**
   * Hiển thị Dynamic theo `category_id`.
   * Ví dụ: Lốp xe (Tire) hiện Width/Rim/Profile. Nhớt (Oil) hiện Dung tích/Độ nhớt. Cần map icon tương ứng ở Frontend.
3. **Sticky Footer:**
   * Luôn nằm cố định ở đáy màn hình (z-index cao nhất) để user luôn bấm mua được dù đang scroll ở đâu.
4. **Cart Badge:**
   * Số lượng trên icon giỏ hàng phải đồng bộ realtime với local storage hoặc server cart.
