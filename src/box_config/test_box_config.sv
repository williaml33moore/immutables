`timescale 1s/1ms

`include "uvm_macros.svh"

program test_box_config();

import uvm_pkg::*;

`include "immutable_object.sv"
`include "box_config_interface.svh"

typedef class box_config;
typedef class box_config_abstract;
typedef class box_config_copier;

`include "box_config_factory.svh"
`include "box_config_factory_generic.svh"
`include "box_config_copier.svh"
`include "box_config_abstract.svh"
`include "box_config.svh"
`include "box_config_variant_cube.svh"
`include "box_config_variant_rectangle.svh"
`include "box_config_mutable.svh"

function void main();
  uvm_object object;
    begin : hello_world
        `uvm_info($sformatf("%m"), "Hello, world!", UVM_MEDIUM)
    end
    begin : create_box_config
        box_config_abstract box_cfg;

        box_cfg = box_config::factory_type::type_id::create("factory").create_new("box_cfg", 10, 20, 30);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();
    end
    begin : create_box_config_mutable_random
        box_config_mutable tmp;
        int success;

        tmp = box_config_mutable::type_id::create("tmp");
        repeat (10) begin
            success = tmp.randomize() with {length < 10; width < 100; height < 1000;};
            assert (success);
            `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
            tmp.print();
        end
    end
    begin : copy_mutable_to_immutable
        box_config_mutable tmp;
        box_config box_cfg;
        int success;

        tmp = box_config_mutable::type_id::create("tmp");
        success = tmp.randomize() with {length < 10; width < 100; height < 1000;};
        assert (success);
        `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
        tmp.print();

        box_cfg = box_config::create_copy("box_cfg", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == tmp.get_height());
    end
    begin : copy_to_all_variants
        box_config_mutable tmp;
        box_config_abstract box_cfg;
        int success;
        int side;

        tmp = box_config_mutable::type_id::create("tmp");
        success = tmp.randomize() with {length < 10; width < 100; height < 1000;};
        assert (success);
        `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
        tmp.print();

        box_cfg = box_config::create_copy("box_cfg", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == tmp.get_height());

        box_cfg = box_config_variant_cube::create_copy("box_cfg_cube", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        side = tmp.get_length();
        if (tmp.get_width() > side) side = tmp.get_width();
        if (tmp.get_height() > side) side = tmp.get_height();
        assert (box_cfg.get_name() == "box_cfg_cube");
        assert (box_cfg.get_length() == side);
        assert (box_cfg.get_width() == side);
        assert (box_cfg.get_height() == side);

        box_cfg = box_config_variant_rectangle::create_copy("box_cfg_rectangle", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg_rectangle");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == 0);
    end
    begin : factory_copy
        box_config_mutable tmp;
        box_config_abstract box_cfg;
        int success;
        int side;

        tmp = box_config_mutable::type_id::create("tmp");
        success = tmp.randomize() with {length < 10; width < 100; height < 1000;};
        assert (success);
        `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
        tmp.print();

        box_cfg = box_config::factory_type::type_id::create("factory").create_copy("box_cfg", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == tmp.get_height());

        box_cfg = box_config_variant_cube::factory_type::type_id::create("factory").create_copy("box_cfg_cube", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        side = tmp.get_length();
        if (tmp.get_width() > side) side = tmp.get_width();
        if (tmp.get_height() > side) side = tmp.get_height();
        assert (box_cfg.get_name() == "box_cfg_cube");
        assert (box_cfg.get_length() == side);
        assert (box_cfg.get_width() == side);
        assert (box_cfg.get_height() == side);

        box_cfg = box_config_variant_rectangle::factory_type::type_id::create("factory").create_copy("box_cfg_rectangle", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg_rectangle");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == 0);
    end
    begin : factory_param_copy
        box_config_mutable tmp;
        box_config_abstract box_cfg;
        int success;
        int side;

        tmp = box_config_mutable::type_id::create("tmp");
        success = tmp.randomize() with {length < 10; width < 100; height < 1000;};
        assert (success);
        `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
        tmp.print();

        box_cfg = box_config_factory_generic#(box_config)::type_id::create("factory").create_copy("box_cfg", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == tmp.get_height());

        box_cfg = box_config_factory_generic#(box_config_variant_cube)::type_id::create("factory").create_copy("box_cfg_cube", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        side = tmp.get_length();
        if (tmp.get_width() > side) side = tmp.get_width();
        if (tmp.get_height() > side) side = tmp.get_height();
        assert (box_cfg.get_name() == "box_cfg_cube");
        assert (box_cfg.get_length() == side);
        assert (box_cfg.get_width() == side);
        assert (box_cfg.get_height() == side);

        box_cfg = box_config_factory_generic#(box_config_variant_rectangle)::type_id::create("factory").create_copy("box_cfg_rectangle", tmp);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        assert (box_cfg.get_name() == "box_cfg_rectangle");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == 0);
    end
    begin : copy_immutable_to_mutable
        box_config_mutable tmp;
        box_config_abstract box_cfg;
        int success;

        box_cfg = box_config::factory_type::type_id::create("factory").create_new("box_cfg", 2, 4, 6);
        `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
        box_cfg.print();

        tmp = box_config_mutable::type_id::create("tmp");
        tmp.copy(box_cfg);
        `uvm_info($sformatf("%m"), tmp.convert2string(), UVM_MEDIUM)
        tmp.print();

        // uvm_object::do_copy() doesn't copy the name
        assert (box_cfg.get_name() == "box_cfg");
        assert (box_cfg.get_length() == tmp.get_length());
        assert (box_cfg.get_width() == tmp.get_width());
        assert (box_cfg.get_height() == tmp.get_height());
    end
    begin : type_overrides
        box_config_abstract box_cfg;
        int success;
        struct {
            uvm_object_wrapper factory_type;
        } data[] = '{
            '{factory_type: box_config::factory_type::get_type()},
            '{factory_type: box_config_factory_generic#(box_config)::get_type()},
            '{factory_type: box_config_variant_cube::factory_type::get_type()},
            '{factory_type: box_config_factory_generic#(box_config_variant_cube)::get_type()},
            '{factory_type: box_config_variant_rectangle::factory_type::get_type()},
            '{factory_type: box_config_factory_generic#(box_config_variant_rectangle)::get_type()}
        };

        foreach (data[i]) begin
            uvm_factory::get().set_type_override_by_type(box_config_factory::get_type(), data[i].factory_type);
            box_cfg = box_config_factory::type_id::create("factory").create_new("box_cfg", 10, 20, 30);
            `uvm_info($sformatf("%m"), box_cfg.convert2string(), UVM_MEDIUM)
            box_cfg.print();
        end
    end
endfunction : main

initial main();

endprogram : test_box_config
