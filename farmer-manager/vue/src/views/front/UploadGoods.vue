<template>
  <div class="main-content">
    <div class="form-container" style="width: 80%; margin: 20px auto">
      <!-- 标题部分 -->
      <div style="font-size: 17px; margin: 20px 10px">上架货物</div>

      <!-- 表单部分 -->
      <el-form label-width="100px" style="padding-right: 50px" :model="form" :rules="rules" ref="formRef">
        <el-form-item label="商品图片">
          <el-upload
              class="avatar-uploader"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              list-type="picture"
              :on-success="handleAvatarSuccess"
          >
            <el-button type="primary">上传图片</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item prop="name" label="商品名称">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="price" label="商品价格">
          <el-input v-model="form.price" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="num" label="商品库存">
          <el-input v-model="form.num" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="save">提交</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      form: {
        name: '',
        price: '',
        num: '',
        img: ''
      },
      rules: {
        name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        price: [{ required: true, message: '请输入商品价格', trigger: 'blur' }],
        num: [{ required: true, message: '请输入商品库存', trigger: 'blur' }]
      }
    };
  },
  methods: {
    handleAvatarSuccess(response, file, fileList) {
      this.form.img = response.data
    },
    save() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          this.$request.post('/goods/upload', {
            ...this.form,
            userId: this.user.id
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('商品上架成功');
              this.$router.push('/front');
            } else {
              this.$message.error(res.msg);
            }
          });
        }
      });
    }
  }
};
</script>