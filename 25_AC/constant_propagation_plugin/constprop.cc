#include <gcc-plugin.h>
#include <plugin-version.h>
#include <tree.h>
#include <tree-ssa.h>
#include <tree-pass.h>
#include <tree-pretty-print.h>
#include <function.h>
#include <basic-block.h>
#include <gimple.h>
#include <gimple-iterator.h>
#include <gimple-pretty-print.h>
#include <context.h>
#include <hash-map.h>
#include <iostream>

int plugin_is_GPL_compatible;

// 변수 이름 → 상수 값을 저장할 해시 맵
static hash_map<tree, tree> const_env;
static bool ischanged = true;

// tree_code 를 출력하는 함수
// void print_tree_code() {
//   for (int code = 0; code < NUM_TREE_CODES; ++code) {
//         std::cout << code << ": " << tree_code_name(code) << "\n";
//   }
// }

void print_tree_value(tree t) {
  print_generic_expr(stdout, t);
  fprintf(stdout, "\n");
}

void print_gimple_value(gimple* g) {
  print_gimple_stmt(stdout, g, 0);
  fprintf(stdout, "\n");
}

// phi node에서 모든 operand값이 동일한 상수라면 해당 상수로 propagation
static void propagate_constants_phi(function* fun) {
  basic_block bb;
  FOR_EACH_BB_FN(bb, fun) {
    gphi_iterator gpi = gsi_start_phis(bb);
    for ( ; !gsi_end_p(gpi); gsi_next(&gpi)) {
      gimple *stmt = gsi_stmt(gpi);

      tree lhs = gimple_phi_result(stmt);
      // print_tree_value(lhs);
      int n = gimple_phi_num_args(stmt);

      tree first_const = NULL_TREE;
      bool is_same_const = true;

      for (int i = 0; i < n; i++) {
        tree arg = gimple_phi_arg_def(stmt, i);
        // print_tree_value(arg);

        // if arg is constant, get the constant
        if (const_env.get(arg) != NULL) {
            arg = *const_env.get(arg);
        }
        
        // if arg is not constant, break and don't propagation
        if (!TREE_CONSTANT(arg)) {
          is_same_const = false;
          break;
        }

        // if const_var is null, assign arg into first_const_var
        if (first_const == NULL_TREE) {
          first_const = arg;
        } 

        // compare current arg and const_var
        // if is same, check other arg
        // if is diff, break and don't propagation
        else if (!tree_int_cst_equal(arg, first_const)) {
          is_same_const = false;
          break;
        }
      }

      // propagation
      if (is_same_const && first_const != NULL_TREE) {
        const_env.put(lhs, first_const);
      }
    }
  }
}

static void propagate_constants(function *fun) {
    basic_block bb;
    
    // 분석하고자 하는 함수의 basic block을 순차적으로 모두 순회
    FOR_EACH_BB_FN(bb, fun) {
        gimple_stmt_iterator gsi = gsi_start_bb(bb);

        for ( ; !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple* stmt = gsi_stmt(gsi);

            if (is_gimple_assign(stmt)) {
                tree lhs = gimple_assign_lhs(stmt);
                tree rhs1 = gimple_assign_rhs1(stmt);

                enum tree_code rhs_code = gimple_assign_rhs_code(stmt);

                // x = constant
                if (rhs_code == INTEGER_CST) {
                    const_env.put(lhs, rhs1);
                }
        
                // x = y
                else if (rhs_code == SSA_NAME) {
                    tree v = gimple_assign_rhs1(stmt);
                    if (const_env.get(v) != NULL) {
                        v = *const_env.get(v);
                    }
                    if (!ischanged) {
                      gimple_assign_set_rhs_from_tree(&gsi, v);
                    }
                    const_env.put(lhs, v);

                }

                // x = y + constant or x = constant + y
                else if (COND_EXPR <= rhs_code <= BIT_AND_EXPR) {
                    tree op0 = gimple_assign_rhs1(stmt);
                    tree op1 = gimple_assign_rhs2(stmt);

                    // 둘 다 상수면 계산
                    if (TREE_CODE(op0) == INTEGER_CST && TREE_CODE(op1) == INTEGER_CST) {
                        tree result = fold_binary(rhs_code, TREE_TYPE(op0), op0, op1);
                        if (!ischanged) {
                          gimple_assign_set_rhs_from_tree(&gsi, result);
                        }
                        const_env.put(lhs, result);
                    }
                    // 하나라도 const_env에 있으면 대체
                    else {
                        if (const_env.get(op0) != NULL) {
                            op0 = *const_env.get(op0);
                        }
                        if (const_env.get(op1) != NULL) {
                            op1 = *const_env.get(op1);
                        }
                        if (TREE_CODE(op0) == INTEGER_CST && TREE_CODE(op1) == INTEGER_CST) {
                            tree result = fold_binary(rhs_code, TREE_TYPE(op0), op0, op1);
                            if (!ischanged) {
                              gimple_assign_set_rhs_from_tree(&gsi, result);
                            }
                            const_env.put(lhs, result);
                        }
                    }
                }
            }
        }
    }
}

static unsigned int run_constprop_pass(void) {
    const_env.empty();  // 매 실행마다 초기화
    ischanged = true;
    bool is_changed_phi = true;

    while(ischanged) {
      ischanged = is_changed_phi;
      int before_prop_len = const_env.elements();
      // std::cout << "len(before): " << before_prop_len << std::endl;

      propagate_constants(cfun);
      int after_prop_len = const_env.elements();
      // std::cout << "len(after): " << after_prop_len << std::endl;
      if (before_prop_len == after_prop_len) { 
        ischanged = false;
      }
      
      propagate_constants_phi(cfun);
      int after_prop_lens = const_env.elements();
      // std::cout << "len(after phi): " << after_prop_lens << std::endl;
      if (after_prop_len == after_prop_lens) { 
        is_changed_phi = false;
      }
    }
    
    return 0;
}

namespace {
const pass_data constprop_pass_data = {
    GIMPLE_PASS, "constprop", OPTGROUP_NONE, TV_NONE,
    PROP_gimple_any, 0, 0, 0
};

struct constprop_pass : gimple_opt_pass {
    constprop_pass(gcc::context *ctx) : gimple_opt_pass(constprop_pass_data, ctx) {}
    opt_pass *clone() override { return new constprop_pass(g); }
    unsigned int execute(function *fun) override {
        return run_constprop_pass();
    }
};
} // namespace

int plugin_init(struct plugin_name_args *plugin_info,
                struct plugin_gcc_version *version) {
    struct register_pass_info info;
    info.pass = new constprop_pass(g);
    info.reference_pass_name = "ssa";
    info.ref_pass_instance_number = 1;
    info.pos_op = PASS_POS_INSERT_AFTER;

    register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP, nullptr, &info);
    return 0;
}

