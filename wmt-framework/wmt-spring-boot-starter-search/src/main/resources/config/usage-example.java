// 使用示例代码

// 1. 实体类示例
@Searchable(index = "user", fields = {"name", "email"})
public class User {
    
    @SearchField(type = FieldType.TEXT, searchable = true)
    private String name;
    
    @SearchField(type = FieldType.KEYWORD, sortable = true)
    private String email;
    
    @SearchField(type = FieldType.LONG, aggregatable = true)
    private Long age;
    
    // getters and setters
}

// 2. 服务类示例
@Service
public class UserSearchService {
    
    @Autowired
    private SearchService searchService;
    
    public SearchResult<User> searchUsers(String keyword, int page, int size) {
        SearchRequest request = new SearchRequest()
                .setIndex("user")
                .setKeyword(keyword)
                .setPage(page)
                .setSize(size)
                .setFields(Arrays.asList("name", "email"));
        
        return searchService.search(request, User.class);
    }
    
    public void indexUser(User user) {
        searchService.index("user", user.getId().toString(), user);
    }
    
    public void deleteUser(String userId) {
        searchService.delete("user", userId);
    }
}

// 3. 控制器示例
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired
    private UserSearchService userSearchService;
    
    @GetMapping("/search")
    public SearchResult<User> searchUsers(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return userSearchService.searchUsers(keyword, page, size);
    }
    
    @PostMapping
    public void createUser(@RequestBody User user) {
        userSearchService.indexUser(user);
    }
    
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable String id) {
        userSearchService.deleteUser(id);
    }
}
