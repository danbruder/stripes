use simple_syrup::*;

#[tokio::main]
async fn main() {
    let db = SimpleSqlite::new("data.db");
    let schema = Schema::build(QueryRoot, MutationRoot, EmptySubscription);
    sqlx::migrate!().run(&db.pool()).await.unwrap();

    SimpleGraphql::new(schema)
        .with_sqlite(db)
        .with_spa("assets/public", "assets/public/index.html")
        .run()
        .await
}

struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn items(&self, ctx: &Context<'_>) -> Result<Vec<Item>> {
        let pool = ctx.data::<SqlitePool>()?;

        let result = sqlx::query_as!(Item, "SELECT * FROM item")
            .fetch_all(&*pool)
            .await?;
        Ok(result)
    }
}

struct MutationRoot;

#[Object]
impl MutationRoot {
    async fn create_item(&self, ctx: &Context<'_>, title: String) -> Result<Item> {
        let pool = ctx.data::<SqlitePool>()?;
        let item = Item::new(&title);

        sqlx::query!(
            r#"
            INSERT INTO item (id, title, complete)
            VALUES (?1, ?2, ?3);
            "#,
            item.id,
            item.title,
            item.complete
        )
        .execute(&*pool)
        .await?;

        Ok(item)
    }

    async fn update_item(&self, ctx: &Context<'_>, id: String, input: ItemInput) -> Result<Item> {
        let pool = ctx.data::<SqlitePool>()?;
        let mut tx = pool.begin().await?;

        sqlx::query!(
            r#"
            UPDATE 
                item 
            SET 
                title=?2,
                complete=?3
            WHERE
                id=?1
            "#,
            id,
            input.title,
            input.complete
        )
        .execute(&mut tx)
        .await?;

        let result = sqlx::query_as!(Item, "SELECT * FROM item WHERE id=?1", id)
            .fetch_one(&mut tx)
            .await?;
        tx.commit().await?;

        Ok(result)
    }
}

#[derive(SimpleObject)]
struct Item {
    id: String,
    title: String,
    complete: bool,
}

#[derive(InputObject)]
struct ItemInput {
    title: String,
    complete: bool,
}

impl Item {
    pub fn new(title: &str) -> Self {
        Self {
            id: Uuid::new_v4().to_string(),
            title: title.to_string(),
            complete: false,
        }
    }
}
